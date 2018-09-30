count = 0

def foo(s):
    return len(s)

class bar(object):
    p = True

    def baz(self, xx) -> str:
        global count
        x = 0
        y = 1

        def qux(y):
            nonlocal x
            if x > y:
                x = -1

        for x in xx:
            self.p = x == 2

        qux(0) # This is a comment.

        count = count + 1

        while x <= 0:
            if self.p:
                xx[0] = xx[1]
                self.p = not self.p
                x = x + 1
            elif foo("Long"[0]) == 1:
                return self is None

        return "Nope"

print(bar().baz([1,2]))

