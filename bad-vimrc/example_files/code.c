/* This code was made by my friend, sultanxda.
 * Talk to him about how bad this code is.
 * This code is not maintained.*/

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TARGETS_FILE "targets.txt"
#define CENSOR_FILE  "censor.txt"

static void censor_words(char *censor_str, long censor_len,
	char **target_words, long nr_targets);
static char **get_target_words(const char *str, long nr_words);
static long get_word(char **buf, const char *str);
static long get_word_count(const char *str);
static bool is_word_letter(char c);
static long read_file(char **buf, const char *filename);
static void write_file(const char *buf, long len, const char *filename);

int main(void)
{
	char **target_words;
	char *censor_str, *targets_str;
	long censor_len, nr_targets;
	int i;

	censor_len = read_file(&censor_str, CENSOR_FILE);
	if (!censor_str)
		return 1;

	read_file(&targets_str, TARGETS_FILE);
	if (!targets_str)
		goto free_censor_str;

	nr_targets = get_word_count(targets_str);
	if (!nr_targets) {
		printf("No target words in %s\n", TARGETS_FILE);
		goto free_targets_str;
	}

	target_words = get_target_words(targets_str, nr_targets);
	free(targets_str);
	if (!target_words) {
		printf("Failed to parse target words\n");
		goto free_censor_str;
	}

	censor_words(censor_str, censor_len, target_words, nr_targets);

	for (i = 0; i < nr_targets; i++)
		free(target_words[i]);
	free(target_words);

	write_file(censor_str, censor_len, CENSOR_FILE);

	free(censor_str);
	return 0;

free_targets_str:
	free(targets_str);
free_censor_str:
	free(censor_str);
	return 1;
}

static void censor_words(char *censor_str, long censor_len,
	char **target_words, long nr_targets)
{
	char *word;
	long len;
	int i, j;

	for (i = 0; i < censor_len; i++) {
		bool is_target = false;

		if (!is_word_letter(censor_str[i]))
			continue;

		len = get_word(&word, censor_str + i);
		if (!word)
			break;

		for (j = 0; j < nr_targets; j++) {
			if (!strcmp(target_words[j], word)) {
				is_target = true;
				break;
			}
		}

		free(word);

		if (is_target)
			memset(censor_str + i + 1, '*', len - 1);

		i += len;
	}
}

static char **get_target_words(const char *str, long nr_words)
{
	char **words, *buf;
	long len;
	int i;

	words = malloc(nr_words * sizeof(char *));
	if (!words) {
		printf("%s: malloc failed! Line %d\n", __func__, __LINE__);
		return NULL;
	}

	for (i = 0; i < nr_words; i++) {
		for (; *str && !is_word_letter(*str); str++);

		len = get_word(&buf, str);
		if (!buf)
			goto free_words;

		words[i] = buf;
		str += len;
	}

	return words;

free_words:
	while (i--)
		free(words[i]);
	free(words);
	return NULL;
}

static long get_word(char **buf, const char *str)
{
	long len;

	for (len = 0; *str && is_word_letter(*str); str++, len++);

	*buf = malloc(len + 1);
	if (!*buf) {
		printf("%s: malloc failed! Line %d\n", __func__, __LINE__);
		return 0;
	}

	memcpy(*buf, str - len, len);
	(*buf)[len] = '\0';

	return len;
}

static long get_word_count(const char *str)
{
	long count;

	for (count = 0;;) {
		for (; *str && !is_word_letter(*str); str++);
		for (; *str && is_word_letter(*str); str++);
		if (!*str)
			break;
		count++;
	}

	return count;
}

static bool is_word_letter(char c)
{
	return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '-';
}

static long read_file(char **buf, const char *filename)
{
	FILE *fp;
	long len;

	fp = fopen(filename, "rb");
	if (!fp) {
		printf("Failed to open file %s for reading\n", filename);
		return 0;
	}

	fseek(fp, 0, SEEK_END);
	len = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	*buf = malloc(len + 1);
	if (!*buf) {
		printf("%s: malloc failed! Line %d\n", __func__, __LINE__);
		len = 0;
		goto close_file;
	}

	fread(*buf, 1, len, fp);
	(*buf)[len] = '\0';

close_file:
	fclose(fp);
	return len;
}

static void write_file(const char *buf, long len, const char *filename)
{
	FILE *fp;

	fp = fopen(filename, "wb");
	if (!fp) {
		printf("Failed to open %s for writing\n", filename);
		return;
	}

	fwrite(buf, 1, len, fp);
	fclose(fp);
}
