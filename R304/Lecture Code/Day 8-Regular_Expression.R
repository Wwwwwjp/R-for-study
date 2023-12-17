rm(list = ls()) # initialization



##########################Pattern Matching##########################
# like searing and replacing in any editor

# 1. search

# grep(pattern, x, ignore.case = FALSE, value = FALSE)
# returns a vector of indices/values of elements of character (string) vector x matching pattern.

# raw data from a class list for demo
a = c("Brown,Joe 123456789 jbrown@wisc.edu 1000",
      "Roukos,Sally    456789123 sroukos@wisc.edu 5000",
      "Chen,Jean 789123456 chen@wisc.edu 24000",
      "Juniper,Jack 345678912 jjuniper@wisc.edu 300000")
a

# search by grep()
grep(pattern = "j", x = a)
grep(pattern = "j", x = a, ignore.case = TRUE, value = TRUE)



# 2. replace

# replace by sub() or gsub()
sub(pattern = "e", replacement = "E", x = a) # first "e" -> "E" (like replace the first)
gsub(pattern = "e", replacement = "_E_", x = a) # all "e" -> "_E_" (g means globally, like replace all)


#########################Regular Expressions########################
?regex
# do searching & relacing with much more flexibilities
# widely used in most programming languages with minor differences
# the best tool to handle strings and trim raw data

# two online regex testers, the efficient way to learn regex is 
# trial and error in these testers first
# then, try these regex in R (our ultimate goal)
# Watch the corresponding video on Canvas > Files > Lecture Code > Day8-Online Regex Tester.mp4 for more details

# https://spannbaueradam.shinyapps.io/r_regex_tester/, 
# read its help at https://adamspannbauer.github.io/2018/01/16/r-regex-tester-shiny-app/
# a tester especially for R. Highly recommended. Its function is naive.
# not good for multiline pattern involving ^, $, \<, and \>

# The testing procedure is:
# 1. Fill in Test String without double quotes, like the one below (without #)
#  Brown,Joe 123456789 jbrown@wisc.edu 1000
#  Roukos,Sally    456789123 sroukos@wisc.edu 5000
#  Chen,Jean 789123456 chen@wisc.edu 24000
#  Juniper,Jack 345678912 jjuniper@wisc.edu 300000
# 2. Fill in Matching Pattern with your regex, like
#     \\d (double \\, or check Auto Escape Backslashes on the left)
#     or, any regex in pattern parameter
# 3. Click Reg-Explanation to understand the rule in details
# 4. Watch Results carefully to learn


# https://regexr.com/, good for the general cases in other languages, such as Javascript
# powerful tester with much more demos
# similar testing procedure (check Menu > Help on the left)
# just fill in Expression and Text, then watch Tools
# setting: check Flags > multiline on the right (good support for multiple lines)
#          click Tools > Replace on the bottom (good support for replacement but not good for \1)
# single \, not double \ for Expression
# not good for \< and \>



# basic syntax, like a wildcard character, *.* in PC
# letters and digits (a-z, A-Z, 0-9) match them[aeiou]selves
# . matches any single character
# \d = [0123456789] matches a digit character: 0123456789 => Actually, "\\d" in R
# \w matches a word character: a letter, digit, or _ (underscore) => Actually, "\\w" in R
# \s matches a space character: space, tab, and newline (and some others) => Actually, "\\s" in R
# \D, \W and \S negate the previous three classes => Actually, "\\D", "\\W", "\\S" in R



# similar to branch
# square brackets, [...], enclose a character class that matches any one of its characters;
# except that [^...] matches any one character not in the class
# try at https://spannbaueradam.shinyapps.io/r_regex_tester/
gsub(pattern = "[aeiou]", replacement = "", x = a) #strip vowels
gsub(pattern = "[^aeiou]", replacement = "", x = a) #strip non-vowels

# ^ matches the beginning of a line ($ matches the end)
# try at https://regexr.com/
grep(pattern = "^r", x = a) #begin with "r" in a line
grep(pattern = "^r", ignore.case = TRUE, x = a)

# \< matches the beginning of a word (\> matches the end)
# This doesn't work in both online testers unfortunately. Just try in R here.
grep(pattern = "e\\>", x = a) #end with "e" in a word
# note: double backslashes, "e\\v" in R => e\v in regex


# | means or
# try at https://spannbaueradam.shinyapps.io/r_regex_tester/
grep(pattern = "Joe|Jack", x = a)
grep(pattern = "J(oe|ack)", x = a) #same
grep(pattern = "J(o|a)", x = a) # J(o|a) = Jo|Ja == J[oa]



# similar to loop
# repetition quantifiers in {...} indicate matching the previous expression
# - {n} exactly n times
# - {n,} n or more times 
# shorthands: * = {0,}, + = {1,}
# - {n,m} n to m times 
# shorthand: ? means {0,1} or optional
# try at https://regexr.com/ with \d instead of \\d
grep(pattern = "\\d{4}$", x = a) # 4 digits, end-of-line
grep(pattern = " \\d{4}$", x = a) # space, 4 digits, end-of-line
grep(pattern = " \\d{4,5}$", x = a) # space, 4 or 5 digits, end-of-line

# repetition is maximal, except that appending ? to a quantifier makes it minimal
# try at https://regexr.com/ with \d instead of \\d
gsub(pattern = "\\d{1,}" , replacement = "X", x = a) # maximal matching, replace all
gsub(pattern = "\\d{1,}?" , replacement = "X", x = a) # minimal/lazy matching, ? means lazy/matching matching, instead of {0,1}, replace all



# subset, similar to a function 
# good for HW3
# parentheses, (...), enclose an expression
# a backreference \N (where N is in 1:9) refers to what the Nth enclosed expression matched

# This example is good for Day8 topic and HW3 part 2.
# How to extract a link from the source code (HTML) of a webpage
sourcecode = "blah blah blah ... <a href=http://www.google.com>Google</a> blah ..."

# try at https://regexr.com/
sub(pattern = ".*<a href=(.*)>.*" , replacement = "\\1", x = sourcecode)
#wrong! match too much, using the last ">" as the ending delimiter

# try at https://regexr.com/
sub(pattern = ".*<a href=(.*?)>.*" , replacement = "\\1", x = sourcecode) 
# one fix, ? means lazy matching, using the first ">" as the ending delimiter
sub(pattern = ".*<a href=(.*.com)>.*" , replacement = "\\1", x = sourcecode)
# one more fix, without using ?

# try at https://regexr.com/
sub(pattern = ".*<a href=([^>]*)>.*", replacement = "\\1", x = sourcecode) 
# another fix, the same function, [^>]* means any string without ">"


# rewrite "last,first ID email ..." to ".csv": "first,last,user,ID"
# try at https://regexr.com/ with single \, instead of double \
b = sub(pattern = "(\\w+),(\\w+) +(\\d+) +(\\w+).*", replacement = "\\2,\\1,\\4,\\3", x = a)
b

# read b as a .csv file to d
# textConnection will treat the var b as a file
d = read.csv(file = textConnection(b), header = FALSE, col.names = c("first", "last", "user", "ID"))
d

# . \ | ( ) [ { ^ $ * + ? are metacharacters with special meaning
# to use them as regular characters, escape them with \ (doubled, as described above) if necessary.



##########################Splitting Strings#########################
# strsplit(x, split) splits each string in character vector x on regular expression split
strsplit(x = a, split = ",")
strsplit(x = a, split = " +") # separated by 1+ whitespaces
(lists.of.words = strsplit(x = a, split = ",|( +)")) #split a as a list

# different ways
(vector.of.words = unlist(lists.of.words)) #convert to a vector
(m = matrix(vector.of.words, 4, 5, byrow = TRUE)) #convert to a 4x5 matrix
(d = as.data.frame(m)) #convert to data frame
colnames(d) = c("last", "first", "ID", "email", "number") #with column names
d

# summary
# 1. Trial and error in online testers are always the efficient way to learn regex.
# 2. The regex satisfying the given criteria is not unique. Try the simplest one first.
# 3. Quiz 6 is harder than other quizzes. Please follows the hints or 1. & .2 above.