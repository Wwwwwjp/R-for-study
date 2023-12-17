#include <Rcpp.h>
using namespace Rcpp;



// Note: This function is not exported.
//       It is called only by escapeTime() inside.
//       It is used to calculate the distance from the origin.

double distance_from_origin(double x, double y) {
    return sqrt(x * x + y * y);
}



// [[Rcpp::export]]
int escapeTime(double x0, double y0, int limit = 256) {
  double x = x0, y = y0;
  int n_jumps;
  
  for (n_jumps = 0; n_jumps < limit; n_jumps++) {
	  if (distance_from_origin(x, y) >= 2.0)
	    break;
	
	  double old_x = x;
	  double old_y = y; // (Not a necessary variable.)
	
	  x = old_x * old_x - old_y * old_y + x0;
	  y = 2.0 * old_x * old_y + y0;
  }
  
  return n_jumps;
}