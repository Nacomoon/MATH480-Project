from sage.structure.sage_object import SageObject

class Tableau(SageObject):
    tab = []
    var = []

    def __init__(self, A, z):
        T = [[] for i in range(len(A) + 1)]
        variables = ()
        for i in range(len(A)): #this loop goes through each function and collects are the variables
            variables = union(variables,A[i].args())
        variables = union(variables,z.args())
        v1 = len(variables)
        for i in range(len(T)): #this makes a tableux of all zeros and b
            for j in range(v1 + len(A)):
                T[i].append(0)
        for i in range(len(T) - 1): #this fills in the rest of the tableux
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
    
    def _latex_(self):
        return latex(self._matrix_())

    def _repr_(self):
        return self._matrix_().str()

    def _matrix_(self):
        return Matrix(self.tab)
