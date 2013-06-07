︠41965008-21df-46ee-bfda-090428d50087︠
class LPTutSolver(object):
    initialtab = 0
    m = 0
    n = 0
    initialb = 0
    initialc = 0
    tut = False


    def __init__(self, variables, ob, con, maximize = True, tut = False):
        LPtab = self.lptab(variables, ob, con, maximize, tut)
        self.initialb = LPtab["b"]
        self.initialtab = LPtab["lptab"]
        self.initialc = LPtab["c"]
        self.m = self.initialtab.nrows()
        self.n = self.initialtab.ncols()
        self.tut = tut
        print "Initial:"
        print self.initialtab
    ######################################
    def lptab(self, variables, ob, con, maximize = True, tut = False):
        conlist = []
        A = [[] for i in range(len(con))]
        b = [0 for i in range(len(con))]
        if maximize:
            c = [ob.coeff(i) for i in variables]
        else:
            c = [-ob.coeff(i) for i in variables]
        for i in range(len(con)):
            opera = con[i].operator()
            if opera == operator.le:
                A[i] = [con[i].left().coeff(j) for j in variables]
                b[i] = con[i].right()
            elif opera == operator.ge:
                A[i] = [-(con[i].left().coeff(j)) for j in variables]
                b[i] = -con[i].right()
            else:
                A[i] = [con[i].left().coeff(j) for j in variables]
                b[i] = con[i].right()
                conlist.append(i)
        if len(conlist) > 0:
            for i in conlist:
                A.append([])
                A[len(b)] = [-(con[i].left().coeff(j)) for j in variables]
                b.append(-con[i].right())
        A = matrix(A)
        lptab = block_matrix([[A.augment(identity_matrix(A.nrows())),matrix(b).transpose()],[matrix(c).augment(zero_matrix(SR,1,A.nrows())),0]])
        if A.nrows() == 2 and A.ncolumns == 2:
            plotter(A,b)
        return {"lptab": lptab, "A": A, "b": b, "c": c}
    ######################################
    def plotter(self,A,b):
        intcpt1=self.b[0]/self.A[0][1]
        intcpt2=self.b[1]/self.A[1][1]
        slope1=self.A[0][0]/self.A[0][1]
        slope2=self.A[1][0]/self.A[1][1]
        f1=intcpt1-slope1*x
        f2=intcpt2-slope2*x
        root1=find_root(f1==f2,-len(b)^10,len(b)^10)
        root2=find_root(f1==0,-len(b)^10,len(b)^10)
        root3=find_root(f2==0,-len(b)^10,len(b)^10)
        if slope1 > slope2:
            if root1 > 0:
                plot(f1,(x,root2,root1),rgbcolor=hue(1.0),fill=true) + plot(f2,(x,root1,root3),fill=true)
            elif root1==0:
                plot(f1,(x,root1,abs(max(b))),rgbcolor=hue(1.0),fill=true) + plot(f2, (x,root1,abs(max(b))),fill=true)
            else:
                plot(f1,(x,root2,root1),rgbcolor=hue(1.0),fill=true) + plot(f2, (x,root3,root1),fill=true)
        elif slope1 < slope2:
            if root1 > 0:
                plot(f1,(x,root1,abs(max(b))),rgbcolor=hue(1.0),fill=true) + plot(f2,(x,root3,root1), fill=true)
            elif root1==0:
                plot(f1,(x,root1,abs(max(b))),rgbcolor=hue(1.0),fill=true) + plot(f2, (x,root1,abs(max(b))),fill=true)
            else:
                plot(f1,(x,root2,root1),rgbcolor=hue(1.0),fill=true) + plot(f2, (x,root3,root1),fill=true)
    ######################################
    def testers(self, b, c):
        ####Test to see if Tableaux is Primal Feasible
        testP = True
        for i in b:
            if i < 0: #if b is all positive we can proceed with Primal simplex
                testP = False
                break
        ####Test to see if tableaux is Dual Feasible
        testD = False
        if testP != True:
            testD = True
            for i in c:
                if i >= 0: #if last row is all negative we can proceed with Dual Simplex
                    testD = False
                    break

        if testP == False and testD == False:
            print "The linear program is not bounded. We are done." #######Check to make sure this is correct!#####
        return (testP, testD)
    #######################################
    def pivcol(self,tableaux):
        #choose pivot column based on Bland's rule of choosing left most positive value of c
        for i in range(0,self.n):
            if tableaux[self.m-1, i] > 0:
                pivotcolindex = i
                break
            else:
                i += 1
        return pivotcolindex
    #######################################
    def pivrow(self, b, tableaux, pivotcolindex):
        #choose pivot row based on ratios
        pivotcol = tableaux.column(pivotcolindex).list()
        ratios = [] #calculate ratios
        for i in range(len(b)): #only calculate ratios for non-objective rows
            if pivotcol[i] > 0: #makes sure we find ratio that is not dividing by 0 or dividing by a negative.
                ratio = b[i]/pivotcol[i]
                ratios.append(ratio)
            else:
                ratios.append(str("b/Zero"))
        pivotrowindex = ratios.index(min(ratios)) #find index of the minimum ratio. This is our row
        if self.tut:
            print "index of pivotrow: " + str(pivotrowindex)
            print "index of pivotcol: " + str(pivotcolindex)
            print "ratios are: " + str(ratios)

        return pivotrowindex
    #######################################
    def stepG(self,pivotrowindex,pivotcolindex, tableaux):
        #Now that we have the pivot row and pivot column, we can implement Gaussian elimination.
        #Find a, alpha, b
        pivotcol = tableaux.column(pivotcolindex).list()
        a = pivotcol[:pivotrowindex] #define values above pivot point, alpha
        alpha = pivotcol[pivotrowindex] #define alpha
        b = pivotcol[pivotrowindex+1:] #define values below pivot point, alpha
        if self.tut:
            print "a: " + str(a)
            print "alpha: " + str(alpha)
            print "b: " + str(b)
        #Now Build G
        #building top row of G
        aM = Matrix(SR,len(a), a) #turns a into a matrix for future augmenting
        if len(b) != 0: #created if statement to account for when b is the empty vector because changes the structure of G
            I_s = identity_matrix(SR, len(a)) #creates matrix of zeros
            alphaa = (-alpha**-1)*aM
            szeros = zero_matrix(SR, len(a), len(b))
            toprow = I_s.augment(alphaa.augment(szeros))
        else:
            I_s = identity_matrix(SR, len(a)) #creates matrix of zeros
            alphaa = (-alpha**-1)*aM
            toprow = I_s.augment(alphaa)
        #building middle row of G
        center = [alpha**-1]
        centerM = Matrix(SR, 1, 1, [center])
        middlezerosL = zero_matrix(SR, 1, len(a))
        middlezerosR = zero_matrix(SR, 1, len(b))
        middlerow = middlezerosL.augment(centerM.augment(middlezerosR))
        #building bottom row of G
        bM = Matrix(SR, b).transpose() #changes b from a list to a matrix to augment into bottomrow
        if len(a) != 0: #created if statement to account for when a is the empty vector because changes G's structure
            tzeros = zero_matrix(SR, len(b), len(a)) #build zero matrix
            alphab = (-alpha**-1)*bM #builds alpha matrix
            I_t = identity_matrix(SR, len(b)) #builds identity matrix (t X t)
            bottomrow = tzeros.augment(alphab.augment(I_t)) #augments to build bottom row of G
        else:
            alphab = (-alpha**-1)*bM #builds alpha matrix
            I_t = identity_matrix(SR, len(b)) #builds identity matrix (t X t)
            bottomrow = alphab.augment(I_t) #augments to build bottom row of G
        if len(a) == 0: #Changes the structure of G depending if a or b are the empty vector
            G = middlerow.stack(bottomrow)
        elif len(b)== 0:
            G = toprow.stack(middlerow)
        else:
            G = toprow.stack(middlerow.stack(bottomrow))
        if self.tut:
            print "Gaussian elimination matrix: "
            print G
        return G
    #######################################
    def pivot(self, G, tableaux):
        #Now multiply Gaussian matrix by [a, alpha, b] to get the pivoted tableau
        return G * tableaux
    #######################################
    def dualpivrow(self, tableaux):
        #choose pivot row based on largest negative of constraint column
        pivotrowindex = 0
        largestnegative = 10^10 #just put an arbitrarily high number to make the checks work. Assumes all constraints are less than 10^10
        for i in range(0,m):
            if tableaux[i, self.n-1] < 0:
                if abs(tableaux[i, self.n-1]) < largestnegative:
                       largestnegative = abs(tableaux[i, self.n-1])
                       pivotrowindex = i
            else:     #I think you should take this out -Gary
                i += 1
        return pivotrowindex #index of pivot row
    #######################################
    def dualpivcol(self, pivotrowindex, tableaux):
        #Now that we have pivot row, find pivot column based on ratios.
        pivotrow = list(tableaux[pivotrowindex])
        objectiverow = list(tableaux[self.m-1])
        #Note, this ratio portion needs some help on eliminating ratios that are not allowed
        ratios = [] #calculate ratios
        for i in range((self.n-2)): #only calculate ratios for non-objective rows
            if pivotrow[i] != 0:
                ratio = objectiverow[i]/pivotrow[i]
                ratios.append(ratio)
            else:
                ratios.append("b/Zero")
        pivotcolindex = ratios.index(min(ratios)) #find index of the minimum ratio. This is our row
        if self.tut:
            print "index of pivotrow: " + str(pivotrowindex)
            print "index of pivotcol: " + str(pivotcolindex)
            print "ratios are: " + str(ratios)
        return pivotcolindex
    #######################################
    def solver(self):
        tab = self.initialtab
        b = self.initialb
        c = self.initialc
        testres = self.testers(b,c)
        testP = testres[0]
        testD = testres[1]
        tab = self.initialtab
        b = self.initialb
        if testP == True:
            testdone = False

            counter = 1
            while testdone == False:
                ##########Andrea's code goes here, which included brians code for printing in Latex##########
                pivotcol = self.pivcol(tab)
                pivotrow = self.pivrow(b, tab, pivotcol)
                G = self.stepG(pivotrow, pivotcol, tab)
                tab = self.pivot(G, tab)
                b = tab.column(self.n-1).list()[:self.m-1]
                test = True
                for i in b: #if all the numbers in the last col are + we are good
                    if i < 0:
                        test = False
                        break
                if test == False:
                    print "The Linear program is no longer feasible in the Primal Tableaux"#See if there are any other concl.
                    break
                testdone = True
                for i in tab.rows()[self.m-1]: #### testing to see if we are finished or not
                    if i > 0: # if last row is all negative we are done
                        testdone = False
                        break
                if testdone == True:
                    break
                elif counter > 25:
                    break
                else:
                    counter += 1
                if self.tut:     #Pretty Pretty output should probably go here -Gary
                    print "Iteration #" + str(counter)
                    print tab
        elif testD == True:
            print "not yet implemented"
            testdone = True
            while testdone == False:
                pivotrow = self.dualpivrow(tab)
                pivotcol = self.dualpivcol(tab, pivotcol)
                G = self.stepG(pivotrow, pivotcol, tab)
                tab = self.pivot(G, tab)
                b = tab.column(self.n-1).list()[:self.m-1]
                test = True
                for i in b: #if all the numbers in the last col are + we are good
                    if i > 0:
                        test = False
                        break
                if test == False:
                    print "The Linear program is no longer feasible in the Dual Simplex method"#See if there are any other concl.
                    break
                testdone = True
                for i in tab.rows()[self.m-1]: #### testing to see if we are finished or not
                    if i < 0: # if last row is all negative we are done
                        testdone = False
                        break
                if testdone == True:
                    #### (Brian) print optimal information in Latex form#####
                    break
                elif counter > 25:
                    break
                else:
                    counter += 1
                if self.tut:  #dual pretty output in here -Gary
                    print "Iteration #" + str(counter)
                    print tab
        print tab #replace with pretty output -Gary
︡00e69c54-1194-4880-ab80-eff9dff4100b︡
︠02e7a568-83fc-4866-8205-5394bf1efdc9︠
variables = var('x,y,z')
ob = 5 * x + 4 * y + 3 * z
con = [2*x+3*y+z <= 5, 4*x+y+2*z <= 11, 3*x+4*y+2*z <= 8]
asd = LPTutSolver(variables,ob,con)
asd.solver()
︡c2760a40-ac7b-40db-adb2-779491f9c105︡{"stdout":"Initial:\n[ 2  3  1  1  0  0| 5]\n[ 4  1  2  0  1  0|11]\n[ 3  4  2  0  0  1| 8]\n[-----------------+--]\n[ 5  4  3  0  0  0| 0]\n[  1   2   0   2   0  -1   2]\n[  0  -5   0  -2   1   0   1]\n[  0  -1   1  -3   0   2   1]\n[  0  -3   0  -1   0  -1 -13]\n"}︡
︠0a07af04-fcdf-4aed-969e-c1e729c3b90b︠
print asd.testers(asd.initialb, asd.initialc)
︡3694558b-6f3d-41f5-9937-7157a0764e1b︡{"stdout":"(True, False)\n"}︡
︠8efdc26d-89c6-4ab7-b827-e771dadfbf5a︠
print asd.initialb
print asd.n
︡5f4063eb-0ec7-44c3-bab2-65c4185d34a3︡{"stdout":"[5, 11, 8]\n7\n"}︡
︠78caaf93-c920-4b8c-96c9-f58afc472936︠
