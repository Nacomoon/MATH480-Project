class LPTab(object):
    
    lptab = 0
    
    def __init__(self, vars, cons, obj, maximization = True):
        A = [[] for i in range(len(cons))]
        b = matrix([i.right() for i in cons]).transpose()
        c = [obj.coeff(i) for i in vars]
        for i in range(len(cons)):
            c.append(0)
        c = matrix(c)
        for i in range(len(cons)):
            A[i] = [cons[i].left().coeff(j) for j in vars]
        A = matrix(A).augment(identity_matrix(len(cons)))
        self.lptab = block_matrix([[A,b],[c,0]])
    
    def _latex_(self):
        return latex(self.lptab)
    
    def __repr__(self):
        return self.lptab.str()
