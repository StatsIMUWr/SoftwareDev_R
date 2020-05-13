#include <Rcpp.h>
#include <boost/math/tools/roots.hpp>
#include <math.h>
#include <tuple> // for std::tuple and std::make_tuple.
#include <boost/math/special_functions/cbrt.hpp> // For boost::math::cbrt.
using namespace Rcpp;

double prcos_single(double x, double mu, double s) {
    return(0.5 * (1 + (x - mu) / s + (1 / M_PI) * sin(M_PI * ((x - mu) / s))));
}

// [[Rcpp::export]]
NumericVector prcos_cpp(NumericVector x, double mu, double s) {
    NumericVector result(x.length());
    for (int i = 0; i < x.length(); ++i) {
        result[i] = 0.5 * (1 + (x[i] - mu) / s + (1 / M_PI) * sin(M_PI * ((x[i] - mu) / s)));
    }
    return(result);
}

// [[Rcpp::export]]
NumericVector prcos_cpp2(NumericVector x, double mu, double s) {
    NumericVector result(x.length());
    for (int i = 0; i < x.length(); ++i) {
        result[i] = prcos_single(x[i], mu, s);
    }
    return(result);
}

class tolerance {
public:
    tolerance(double eps) :
    _eps(eps) {
    }
    bool operator()(double a, double b) {
        return (fabs(b - a) <= _eps);
    }
private:
    double _eps;
};

// [[Rcpp::export]]
NumericVector inverse_prcos_cpp(NumericVector x, double m, double s) {
    tolerance tol = 1e-10;
    NumericVector roots(x.length());
    for(int i = 0; i < x.length(); ++i) {
        std::pair<double, double> result = boost::math::tools::bisect([x, i, m, s](double y) {return(prcos_single(y, m, s) - x[i]);}, m - s, m + s, tol);
        roots[i] = (result.first + result.second) / 2;
    }
    return(roots);
}
