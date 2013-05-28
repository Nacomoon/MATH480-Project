class Tableau(object):

    r"""
    
    I added _latex_ and _matrix_ functions so that you can use latex(a) and matrix(a)
    with a being your tableau object.

    INPUT:

    Takes in list of symbolic expressions representing the constraints of a linear
    programming problem. And a single symbolic expression for the objective
    function of the problem. Use var() to define your variables.

    ``A`` - A list of symbolic expressions, the contraints of the LP.

    ``z`` - A single symbolic expression, the objective function of the LP.

    OUTPUT

    By default it spouts out the tableau as a matrix. Because the set() and
    union() functions return lists with unexpected orderings, I decided
    to save a list with the variables of linear program in the same order
    as they appear in the tableau.

    ``tab`` - The tableau as a list of lists. Each element of the outer elements
    represents a row in the tableau.

    ``var`` - A list of symbolic variables to help determine the order of the 
    variables from the linear program in the tableau.

    EXAMPLES
    
    sage: load("tableau.py")
    sage: var('x1,x2,x3');
    sage: y = [3 * x1 + 2 * x2 - x3 <= 5, 2 * x1 - 2 * x2 <= 4, x3 <= 5];
    sage: z = 2 * x1 + 3*x2 + 4*x3;
    sage: asd = Tableau(y,z)
    [ 3 -1  2  1  0  0  5]
    [ 2  0 -2  0  1  0  4]
    [ 0  1  0  0  0  1  5]
    [-2 -4 -3  0  0  0  0]
    sage: asd.tab
    [[3, -1, 2, 1, 0, 0, 5],
     [2, 0, -2, 0, 1, 0, 4],
     [0, 1, 0, 0, 0, 1, 5],
     [-2, -4, -3, 0, 0, 0, 0]]
    sage: asd.var
    [x1, x3, x2]

    Notice how asd.var isn't x1,x2,x3 as would be expected.
    """

    tab = []
    var = []

    def __init__(self, A, z):
        T = [[] for i in range(len(A) + 1)]
        variables = ()
        for i in range(len(A)): #this loop goes through each function and collects are the variables
            variables = union(variables,A[i].args())
        variables = union(variables,z.args())
        v1 = len(variables)
        for i in range(len(T)): #this makes a matrix of all zeros and b
            for j in range(v1 + len(A)):
                T[i].append(0)
        for i in range(len(T) - 1): #this fills in all of the zeros
            T[i].append(A[i].right())
            T[i][v1 + i] = 1
            for j in range(v1):
                first = 1
                if (variables[j] in A[i].args()):
                    if len(A[i].args()) == 1:
                        first = 0
                    T[i][j] = A[i].left().coeffs(variables[j])[first][0]
        for i in range(v1):                        #adds the objective function
            if (variables[i] in z.args()):
                T[len(T) - 1][i] = -z.coeffs(variables[i])[1][0]
        T[len(T) - 1].append(0)
        self.tab = T
        self.var = variables
        print self
        
    
    def _latex_(self):
        return latex(self._matrix_())

    def __repr__(self):
        return self._matrix_().str()

    def _matrix_(self):
        return Matrix(self.tab)
