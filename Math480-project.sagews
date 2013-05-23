︠45d1f73b-b578-485a-957b-a99bc0b365c5︠
var('x1,x2,x3')
3 * x1 + 2 * x2 - x3 <= 5
︡1406dc17-22c1-469b-8fc8-e0319d917a6b︡{"stdout":"(x1, x2, x3)\n3*x1 + 2*x2 - x3 <= 5\n"}︡
︠45465747-101d-49bf-aa42-fd51ce1d0149︠
y = [3 * x1 + 2 * x2 - x3 <= 5, 2 * x1 - 2 * x2 <= 4, x3 <= 5]
︡f0d19158-2603-4e6b-a329-a2dd2e5ca04b︡
︠94ef3485-a99c-4f7d-ba95-d6ef58c0ecbf︠
y[1].left().coeffs(x2)
︡96a90a9e-9b7b-467e-be62-5f56e50d99cd︡{"stdout":"[[2*x1, 0], [-2, 1]]"}︡
︠46cb63cd-501e-40a1-adc0-7285dfb48430︠

var('a,b,c')
a1 = 2 * a + 4 * b + c
set(a1.args())
︡3fa50883-1f1a-4220-8683-58e359a6ddc5︡{"stdout":"(a, b, c)\nset([c, b, a])\n"}︡
︠5b9860bd-8591-4cdc-9bf1-364b9cd5cf84i︠
latex(set(c))
︡efb4cfcb-c298-4f41-b693-1dd56be7e554︡{"stdout":"\\verb|set([x1,|\\phantom{\\verb!x!}\\verb|x3,|\\phantom{\\verb!x!}\\verb|x2])|\n"}︡
︠a2685491-72b7-4c63-bde7-28e364ce0246︠
len(y)
︡8afd78e1-18fc-4ff6-bbfb-959997751758︡{"stdout":"3\n"}︡
︠2ad668ac-e5ab-4d47-973f-1f8507cfff9a︠
z = 2 * x1 + 3*x2 + 4*x3
z1 = z.coeffs(x2)
z1[1][0]
︡4154a971-e4e1-494f-ba13-a26d83792e68︡{"stdout":"3\n"}︡
︠965abecf-dfb7-44bd-b4e6-ef3e5e88506b︠
a = (2,1,3)
b = (x1,x2,x3)
union(a,b)
︡e6b58ead-0624-43a4-a8b0-7179b3357e77︡{"stdout":"[1, 2, 3, x2, x1, x3]\n"}︡
︠cb4c5bfd-4838-4a67-b124-728b2371545a︠
def tableux(y,z):
    T = [[] for i in range(len(y) + 1)]
    variables = ()
    for i in range(len(y)):                     #this loop goes through each function and collects are the variables
        variables = union(variables,y[i].args())
    variables = union(variables,z.args())
    v1 = len(variables)
    for i in range(len(T)):                     #this makes a tableux of all zeros and b
        for j in range(v1 + len(y)):
            T[i].append(0)
    for i in range(len(T) - 1):                 #this fills in the rest of the tableux
        T[i].append(y[i].right())
        T[i][v1 + i] = 1
        for j in range(v1):
            first = 1
            if (variables[j] in y[i].args()):
                if len(y[i].args()) == 1:
                    first = 0
                T[i][j] = y[i].left().coeffs(variables[j])[first][0]
    for i in range(v1):                        #adds the objective function
        if (variables[i] in z.args()):
            T[len(T) - 1][i] = -z.coeffs(variables[i])[1][0]
    T[len(T) - 1].append(0)
    return T
︡51d61d44-2dd5-4b2e-b6f3-840f8319fd15︡
︠95d38c7b-a42c-4a3c-9cd7-d77c5447a8e2︠
asd = tableux(y,z)
print y,z
print asd
︡82bf8b3c-309d-403c-9bda-4ecc0545b9aa︡{"stdout":"[3*x1 + 2*x2 - x3 <= 5, 2*x1 - 2*x2 <= 4, x3 <= 5] 2*x1 + 3*x2 + 4*x3\n[[3, -1, 2, 1, 0, 0, 5], [2, 0, -2, 0, 1, 0, 4], [0, 1, 0, 0, 0, 1, 5], [-2, -4, -3, 0, 0, 0, 0]]\n"}︡
︠1ea9e9cf-0850-49ef-addf-ee53c8ef1fd0︠
latex(Matrix(asd))
︡b6d44551-1968-4a6b-b01f-566f03e12095︡{"stdout":"\\left(\\begin{array}{rrrrrrr}\n3 & -1 & 2 & 1 & 0 & 0 & 5 \\\\\n2 & 0 & -2 & 0 & 1 & 0 & 4 \\\\\n0 & 1 & 0 & 0 & 0 & 1 & 5 \\\\\n-2 & -4 & -3 & 0 & 0 & 0 & 0\n\\end{array}\\right)\n"}︡
︠fd700468-7f7e-49b7-9396-1a8ec3b78db1︠
