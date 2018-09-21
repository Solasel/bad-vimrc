/* Takes in a file, src, parses through it to find
 * all instruction signal / microcode combinations, and
 * writes the result into a file that logisim2.0 can
 * interpret as a memory file. 
 *
 * Then, indexing into the given RAM/ROM chip will allow
 * you to make comprehensive control signals easily! 
 *
 * Thanks to my good friend sultanxda, for auditing this. */

/* Headers and constants. */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct string_pair {
	char *instr_signal;
	char *microcode;
};

struct signal_pair {
	long instr_code;
	char *microcode;
};

/* Error codes! */
enum errs {
	/* Debug codes. */
	NOT_YET_IMP = 1,
	/* Runtime error codes. */
	BAD_ARGS,
	FOPEN_FAILURE,
	MALLOC_FAILURE
};

/* Function prototypes. */
/* Interprets the contents of src as microcode, and
 * stores the logisim-compatible microcode in dst. */
static int generate_microcode(const char *src, const char *dst);

/* Extracts information from src. */
static int read_src(const char *src, char **fstring,
		int *is_len, int *mc_len, char **inv,
		int *num_x, struct string_pair **x_mc);

/* Generates the final list of microcode. */
static int gen_fin_mc(int num_x, struct string_pair *x_mc,
		int *num_f, struct signal_pair **f_mc);

/* Writes the final microcode to the destination file. */
static int write_mc(const char *dst, int instr_sig_len,
		const char *inv, int num_f, struct signal_pair *f_mc);

/* Counts the occurrences of c in str. */
static int char_occ(const char *str, char c);

/* Returns 2^x, when x is an integer. */
static int two_pow(int x);

/* Unpacks the 'x' containing string
 * pairs into signal pairs in target. */
static void unpack(char *instr_sig, char *mc,
		int *index, struct signal_pair **target);

/* Sorts a len long array of signal_pairs based on their instr_signal. */
static int merge_sort_sig_pairs(int len, struct signal_pair *f_mc);

/* Useful error messages. */
static char *err_msg(enum errs code);

/* Main. */
int main(int argc, char *argv[])
{
	int failure;
	printf("\n");

	/* Makes sure there are an appropriate
	 * number of command-line arguments.   */
	if (argc != 3) {
		printf("ERROR: The generator should take two command-line arguments.\n\n"
			"Sample usage:\n"
			"./{exec} {src file} {target file}\n");
		failure = BAD_ARGS;
		goto end;
	}

	/* Attempts to parse argv[1] -> argv[2] */
	printf("Attempting to generate microcode"
		" based on the contents of '%s'"
		" and store it in '%s'...\n\n",
			argv[1], argv[2]);

	failure = generate_microcode(argv[1], argv[2]);

end:
	/* Reports to the user how the program fared. */
	printf("\n##############################################################\n\n");

	if (failure)
		printf("Microcode generation failed! Neither file has been changed.\n"
			"ERROR MSG: %s\n\n", err_msg(failure));
	else
		printf("Microcode generation successful!\n"
			"'%s' now contains logisim 2.0 compatible microcode!\n\n",
				argv[2]);
	return failure;
}

/* #################
 * ### MAIN CODE ###
 * ################# */

/* Interprets the contents of src as microcode, and
 * stores the logisim-compatible microcode in dst. */
static int generate_microcode(const char *src, const char *dst)
{
	int failure, instr_sig_len, mc_len, num_x, num_f;
	char *fstring, *invalid_mc;
	struct string_pair *x_microcode;
	struct signal_pair *f_microcode;

	/* Extracts the following information from src:
	 * 	instr_sig_len	- length of instr_signals.
	 * 	mc_len		- length of microcode signals.
	 * 	invalid_mc	- invalid microcode (for filler).
	 * 	num_x		- number of 'x' containing instr_signals.
	 * 	x_microcode	- list of 'x' containing instr_signals.
	 * Also outputs fstring, used to free the whole affair at the end. */
	failure = read_src(src, &fstring,
			&instr_sig_len, &mc_len, &invalid_mc,
			&num_x, &x_microcode);
	if (failure) {
		printf("%d: Failed to extract information from '%s'.\n",
				__LINE__, src);
		return failure;
	}

	/* Using x_microcode, generates the following:
	 * 	num_f		- number of final microcode entries.
	 * 	f_microcode	- an unosrted array, containing the
	 * 				final microcode.            */
	failure = gen_fin_mc(num_x, x_microcode,
			&num_f, &f_microcode);
	free(x_microcode);
	if (failure) {
		printf("%d: Failed to generate a final list of microcode.\n",
				__LINE__);
		goto free_fstring;
	}

	/* Sorts the array of microcode. */
	failure = merge_sort_sig_pairs(num_f, f_microcode);
	if (failure) {
		printf("%d: Failed to sort the array of microcode.\n",
				__LINE__);
		goto free_f_microcode;
	}

	/* Using instr_sig_len, invalid_mc, num_f, and
	 * f_microcode, writes microcode to dst.       */
	failure = write_mc(dst, instr_sig_len,
			invalid_mc, num_f, f_microcode);
	if (failure)
		printf("%d: Failed to write microcode to '%s'.\n",
				__LINE__, dst);

free_f_microcode:
	free(f_microcode);
free_fstring:
	free(fstring);
	return failure;
}

/* Extracts information from src. */
static int read_src(const char *src, char **fstring,
		int *is_len, int *mc_len, char **inv,
		int *num_x, struct string_pair **x_mc)
{
	const char *NEWLINES = "\r\n";
	const char *DELIMS = "\t |";

	int failure = 0;
	int i;
	FILE *source;
	long len;
	char *fstringdup, *line;
	char *line_sptr = NULL;

	/* Compile a filestring for src. */
	source = fopen(src, "rb");
	if (!source) {
		printf("%d: Failed to read from file '%s'.\n",
				__LINE__, src);
		return FOPEN_FAILURE;
	}

	fseek(source, 0, SEEK_END);
	len = ftell(source);
	fseek(source, 0, SEEK_SET);

	*fstring = malloc((len + 1) * sizeof(char));
	if (!*fstring) {
		printf("%d: Failed to malloc a filestring for '%s'.\n",
				__LINE__, src);
		fclose(source);
		return MALLOC_FAILURE;
	}

	fread(*fstring, sizeof(char), len, source);
	fclose(source);
	(*fstring)[len] = '\0';

	/* Finds x_mc by parsing through a copy of fstring. */
	fstringdup = malloc((len + 1) * sizeof(char));
	if (!fstringdup) {
		printf("%d: Failed to malloc a duplicate filestring for '%s'.\n",
				__LINE__, src);
		free(*fstring);
		return MALLOC_FAILURE;
	}
	memcpy(fstringdup, *fstring, len + 1);

	line = strtok(fstringdup, NEWLINES);
	*num_x = -2;
	while ((line = strtok(NULL, NEWLINES)))
		(*num_x)++;
	free(fstringdup);

	/* Parses through the file and finds the remaining data. */
	/* First line = instr_sig_len. */
	line = strtok_r(*fstring, NEWLINES, &line_sptr);
	*is_len = strtol(line, NULL, 10);
	/* Second line = mc_len. */
	line = strtok_r(NULL, NEWLINES, &line_sptr);
	*mc_len = strtol(line, NULL, 10);
	/* Third line = invalid_mc. */
	line = strtok_r(NULL, NEWLINES, &line_sptr);
	*inv = line;

	/* Rest of the file = microcode combinations. */
	*x_mc = malloc(*num_x * sizeof(struct string_pair));
	if (!*x_mc) {
		printf("%d: Failed to malloc a list of string_pairs for microcode in '%s'.\n",
				__LINE__, src);
		free(*fstring);
		return MALLOC_FAILURE;
	}

	/* For each line, pulls off the mnemonic and
	 * stores the necessary instr_signal and microcode. */
	for (i = 0; i < *num_x; i++) {
		line = strtok_r(NULL, NEWLINES, &line_sptr);
		strtok(line, DELIMS);
		(*x_mc)[i].instr_signal = strtok(NULL, DELIMS);
		(*x_mc)[i].microcode = strtok(NULL, DELIMS);
	}

	return failure;
}

/* Generates the final list of microcode. */
static int gen_fin_mc(int num_x, struct string_pair *x_mc,
		int *num_f, struct signal_pair **f_mc)
{
	int i, j;

	/* Find the final number of microcode instructions. */
	for (i = 0, *num_f = 0; i < num_x; i++)
		*num_f += two_pow(char_occ(x_mc[i].instr_signal, 'x'));

	*f_mc = malloc(*num_f * sizeof(struct signal_pair));
	if (!*f_mc) {
		printf("%d: Failed to malloc a list of signal_pairs for microcode.\n",
				__LINE__);
		return MALLOC_FAILURE;
	}

	/* For each 'x' containing instruction, unpacks it. */
	for (i = 0, j = 0; i < num_x; i++)
		unpack(x_mc[i].instr_signal, x_mc[i].microcode, &j, f_mc);
	return 0;
}

/* Writes the final microcode to the destination file. */
static int write_mc(const char *dst, int instr_sig_len,
		const char *inv, int num_f, struct signal_pair *f_mc)
{
	int failure = 0;
	int max_addr = two_pow(instr_sig_len);
	int i, addr_i;
	long gap;
	FILE *target;

	target = fopen(dst, "w");
	if (!target) {
		printf("%d: Failed to open file '%s' for writing.\n",
				__LINE__, dst);
		return FOPEN_FAILURE;
	}

	fputs("v2.0 raw\n", target);
	for (i = 0, addr_i = 0; i < num_f; i++) {
		/* Puts in enough gap INVALIDS
		 * between the instructions... */
		gap = f_mc[i].instr_code - addr_i;
		if (gap) {
			fprintf(target, "%ld*", gap);
			fputs(inv, target);
			fputc('\n', target);
		}

		/* And puts the next instruction. */
		fputs(f_mc[i].microcode, target);
		fputc('\n', target);

		addr_i = f_mc[i].instr_code + 1;
	}
	/* Now fill in INVALIDS until the end of memory. */
	gap = max_addr - addr_i;
	if (gap) {
		fprintf(target, "%ld*", gap);
		fputs(inv, target);
		fputc('\n', target);
	}

	fclose(target);
	return failure;
}

/* #################
 * #### HELPERS ####
 * ################# */

/* Counts the occurrences of c in str. */
static int char_occ(const char *str, char c)
{
	int count;
	for (count = 0; (str = strchr(str, c)); str++)
		count++;
	return count;
}

/* Returns 2^x, when x is an integer. */
static int two_pow(int x)
{
	int rv = 1;
	while (x--)
		rv *= 2;
	return rv;
}

/* Unpacks the 'x' containing string
 * pairs into signal pairs in target. */
static void unpack(char *instr_sig, char *mc,
		int *index, struct signal_pair **target)
{
	char *xptr;

	/* If it's a final string, insert the signal pair. */
	if (!(xptr = strchr(instr_sig, 'x'))) {
		(*target)[*index].instr_code = strtol(instr_sig, NULL, 2);
		(*target)[(*index)++].microcode = mc;
		return;
	}

	/* If not, recursively process both of the
	 * combinations in turn, before returning it to
	 * normal for above recursive calls.            */
	*xptr = '0';
	unpack(instr_sig, mc, index, target);
	*xptr = '1';
	unpack(instr_sig, mc, index, target);
	*xptr = 'x';
}

/* Sorts a len long array of signal_pairs based on their instr_signal. */
static int merge_sort_sig_pairs(int len, struct signal_pair *f_mc)
{
	int failure = 0;
	int half = len / 2;
	int i, low_it, upp_it;
	struct signal_pair *lower_half, *upper_half;

	/* If we have an array of length 1, we're done. */
	if (len == 1)
		return 0;

	/* Otherwise, recursively sort the top/bottom... */
	lower_half = malloc(len * sizeof(struct signal_pair));
	if (!lower_half) {
		printf("%d: Failed to malloc the lower_half array for merge-sorting.\n",
				__LINE__);
		return MALLOC_FAILURE;
	}
	upper_half = lower_half + half;

	memcpy(lower_half, f_mc, len * sizeof(struct signal_pair));
	failure = merge_sort_sig_pairs(half, lower_half);
	if (failure) {
		printf("%d: Failed to sort the lower_half array in merge-sorting.\n",
				__LINE__);
		goto free_copy;
	}

	failure = merge_sort_sig_pairs(len - half, upper_half);
	if (failure) {
		printf("%d: Failed to sort the upper_half array in merge-sorting.\n",
				__LINE__);
		goto free_copy;
	}

	/* And merge them together! */
	for (i = 0, low_it = 0, upp_it = 0; i < len; i++) {
		if (upp_it == len - half) {
			f_mc[i] = lower_half[low_it];
			low_it++;
		} else if (low_it == half) {
			f_mc[i] = upper_half[upp_it];
			upp_it++;
		} else if (lower_half[low_it].instr_code < upper_half[upp_it].instr_code) {
			f_mc[i] = lower_half[low_it];
			low_it++;
		} else {
			f_mc[i] = upper_half[upp_it];
			upp_it++;
		}
	}

free_copy:
	free(lower_half);
	return failure;
}

/* Error handler. */
static char *err_msg(enum errs code)
{
	switch (code) {
	/* Debug codes. */
	case NOT_YET_IMP:
		return "Not yet implemented.";
	/* Runtime error codes. */
	case BAD_ARGS:
		return "Bad command-line arguments.";
	case FOPEN_FAILURE:
		return "Failed to open a file.";
	case MALLOC_FAILURE:
		return "Malloc failed.";
	}
	/* This is only here to appease the compiler.
	 * Note that since we're switching on an enum,
	 * we are enforced to handle all of the cases,
	 * so this is guaranteed to never be readhed.  */
	return NULL;
}

