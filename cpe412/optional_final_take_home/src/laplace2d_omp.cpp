/*
 *  Copyright 2015 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*
   to load pgi compiler on dmc.asc.edu first type
      module load pgi

   to compile type
       pgc++ laplace2d_omp.cpp -fast -mp -o laplace2d_omp  

   Creates
      ./laplace2d_omp
   executable.

   to set number of threads through environment variable in bash shell
   (have to do this before you run the program)
   export OMP_NUM_THREADS=8 

   to run -- set number of threads as explained above and then to
             execute from the command line type
   ./laplace2d_omp

*/

/*
   In Final Exam Problem 1 -- OpenMP Version -- used for reference
*/

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>

#include <math.h>
#include <string.h>
#include <omp.h>
#include "timer.h"

#define NN 4096
#define NM 4096

double A[NN][NM];
double Anew[NN][NM];

int main(int argc, char** argv)
{
    const int n = NN;
    const int m = NM;
    const int iter_max = 1000;
    
    const double tol = 1.0e-6;
    double error     = 1.0;
    
    memset(A, 0, n * m * sizeof(double));
    memset(Anew, 0, n * m * sizeof(double));
        
    for (int j = 0; j < n; j++)
    {
        A[j][0]    = 1.0;
        Anew[j][0] = 1.0;
    }
    
    cout << "Jacobi relaxation Calculation: " << n << " x " 
         << m << " mesh" << endl;
    
    StartTimer();
    int iter = 0;
    
    while ( error > tol && iter < iter_max )
    {
        error = 0.0;

        #pragma omp parallel for reduction(+:error)
        for( int j = 1; j < n-1; j++)
        {
            for( int i = 1; i < m-1; i++ )
            {
                Anew[j][i] = 0.25 * ( A[j][i+1] + A[j][i-1]
                                    + A[j-1][i] + A[j+1][i]);
                error = fmax( error, fabs(Anew[j][i] - A[j][i]));
            }
        }
        
        #pragma omp parallel for 
        for( int j = 1; j < n-1; j++)
        {
            for( int i = 1; i < m-1; i++ )
            {
                A[j][i] = Anew[j][i];    
            }
        }

        if(iter % 100 == 0) cout << iter << "  " << setprecision(6) 
                                 << fixed << error << endl;
        
        iter++;
    }

    double runtime = GetTimer();

 
    cout << " total: " << runtime/1000 << " s" << endl;
}
