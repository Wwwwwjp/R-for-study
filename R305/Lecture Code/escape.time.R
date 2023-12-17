escape.time = function(x, y, limit=256) { # for Mandelbrot's fractal
  z0 = complex(real=x, imaginary=y)
  z = z0
  for (i in 0:limit) {
    if (abs(z) > 2) {
      break
    }
    z = z^2 + z0
  }
  return(i)
}
