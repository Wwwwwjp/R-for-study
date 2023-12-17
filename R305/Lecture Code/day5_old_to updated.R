rm(list = ls()) # initialization


#######################R's Debugging Functions######################

# traceback()
?traceback

func.f = function(x) {
  test = 10
  r = x - func.g(x)
  return(r)
}

func.g = function(y) {
  test = y * y
  r = y * func.h(y)
  return(r)
}

func.h = function(z) {
  test = -w
  # browser() # a break point inserted here
  r = log(z) # negative argument of log() causes some trouble!
  if (r < 10)
    return(r^2)
  else
    return(r^3)
}

# func.f(1) # positive argument is OK.
func.f(-1) # negative argument is a trouble-maker!
traceback() # or click Show Traceback
# call order: func.f(x = -1) => func.g(y = x = -1) => func.h(z = y = x = -1)
# func.h() has some problems!

# Why?
# log(-1)
# r = log(-1) #NaN
# r < 10 #NA, not TRUE/FALSE, an error!
# if (r < 10) print(1) else print(2)


# browser()
?browser

# remove the first # in lines 20
# rerun all the lines above
func.f(-1) #enter debugging mode in h()

#Or comment out line 20
#click before line label 22 to set up a breakpoint manually (a circle appears)
#click Source

#Or click the circle to cancel the breakpoint
#click Source
#click Rerun with Debug

#browser() is also good for debugging in branch or loop


#debug(fun)
?debug

#change line 21 into r = exp(z) to remove the bug
#rerun all the lines
#no error messages appear
debug(func.g) #debug only in func.g(), not in func.h() or func.f()
func.f(-1)
undebug(func.g) #causes R to cease stopping in func.g()
func.f(-1)
#debugonce(fun) causes R to stop on the next call only


#trace(what, tracer)
#trace(what=f, tracer=quote(expression)) runs expression when f is called (quote()
#prevents R from evaluating expression before passing it to trace() and f().) e.g.
?trace

mean(2:4+3) #2:7 or else
2:4+3 #simplest way to verify! Even better than trace() usually!

trace(what = mean, tracer = quote(cat(sep = " ", "x=", x, "\n"))) #print the argument of mean()
mean(2:4+3)
untrace(mean) #removes the tracing code from mean()
mean(2:4+3)


#See more in
#https://support.rstudio.com/hc/en-us/articles/205612627-Debugging-with-RStudio
#http://adv-r.had.co.nz/Exceptions-Debugging.html for more.
