︠45d1f73b-b578-485a-957b-a99bc0b365c5︠
var('x1,x2,x3')
3 * x1 + 2 * x2 - x3 <= 5
︡ba95532e-6518-49eb-94dc-8216c5f19858︡{"stdout":"(x1, x2, x3)\n3*x1 + 2*x2 - x3 <= 5\n"}︡
︠45465747-101d-49bf-aa42-fd51ce1d0149︠
y = [3 * x1 + 2 * x2 - x3 <= 5, 2 * x1 - 2 * x2 <= 4, x3 <= 5]
︡0c1c3c8b-b3c5-4166-b793-d952fde0d5aa︡
︠94ef3485-a99c-4f7d-ba95-d6ef58c0ecbf︠
y[1].left().coeffs(x2)
︡e6e89190-6d92-41f3-82dc-396825179e59︡{"stdout":"[[2*x1, 0], [-2, 1]]"}︡
︠46cb63cd-501e-40a1-adc0-7285dfb48430︠
c = y[2].args()
d = y[1].args()
type(set(c))
︡b5f8f972-d2f7-495f-adde-4b3fc3539301︡{"stdout":"<type 'set'>\n"}︡
︠5b9860bd-8591-4cdc-9bf1-364b9cd5cf84︠
set(d)
︡6a48860f-f70c-408a-a086-9bb5744ba5c5︡{"stdout":"set([x1, x2])\n"}︡
︠a2685491-72b7-4c63-bde7-28e364ce0246︠
len(y)
︡f002092d-58b6-4412-94c0-e57eb6cfa1e2︡{"stdout":"3\n"}︡
︠2ad668ac-e5ab-4d47-973f-1f8507cfff9a︠
z = 2 * x1 + 3*x2 + 4*x3
z1 = z.coeffs(x2)
z1[1][0]
︡76b7bdc6-6c4f-4451-a619-e2307ffc502a︡{"stdout":"3\n"}︡
︠965abecf-dfb7-44bd-b4e6-ef3e5e88506b︠
a = (2,1,3)
b = (x1,x2,x3)
union(a,b)
︡1988aa25-c199-4070-b2c2-047a5653b309︡{"stdout":"[1, 2, 3, x2, x1, x3]\n"}︡
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
︡b1c81bc8-c41f-4ed3-98e2-27145bf7527c︡
︠95d38c7b-a42c-4a3c-9cd7-d77c5447a8e2︠
asd = tableux(y,z)
print y,z
print asd
︡f33e764a-ace7-4ab0-887a-d9946cab917c︡{"stdout":"[3*x1 + 2*x2 - x3 <= 5, 2*x1 - 2*x2 <= 4, x3 <= 5] 2*x1 + 3*x2 + 4*x3\n[[3, -1, 2, 1, 0, 0, 5], [2, 0, -2, 0, 1, 0, 4], [0, 1, 0, 0, 0, 1, 5], [-2, -4, -3, 0, 0, 0, 0]]\n"}︡
︠1ea9e9cf-0850-49ef-addf-ee53c8ef1fd0︠
Matrix(asd)
︡80852273-3d31-462f-bd7b-c3f2c97364ae︡{"stdout":"[ 3 -1  2  1  0  0  5]\n[ 2  0 -2  0  1  0  4]\n[ 0  1  0  0  0  1  5]\n[-2 -4 -3  0  0  0  0]\n"}︡
︠fd700468-7f7e-49b7-9396-1a8ec3b78db1︠
