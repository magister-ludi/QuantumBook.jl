
SimpleQuantumExecutionEnvironment sqee = SimpleQuantumExecutionEnvironment()

   #  private static final int dim = 2
function main()
        doGrover(6,7)
#        doGrover(5, 7)
    end

    private static void doGrover(int dim, int solution)
        N = 1 << dim
        double cnt = Math.PI*Math.sqrt(N)/4
        p = Program(dim)
        s0 = Step()
        for (int i = 0  i < dim  i++)
            addGate(s0, Hadamard(i))
        end
        addStep(p, s0)
        Oracle oracle = createOracle(dim, solution)
        oracle.setCaption("O")
        Complex[][] dif = createDiffMatrix(dim)
        Oracle difOracle = Oracle(dif)
        difOracle.setCaption("D")
        for (int i = 1  i < cnt  i++)
            s1 = Step("Oracle "+i)
            addGate(s1, oracle)
            s2 = Step("Diffusion "+i)
            addGate(s2, difOracle)
            s3 = Step("Prob "+i)
            addGate(s3, ProbabilitiesGate(0))
            addStep(p, s1)
            addStep(p, s2)
            addStep(p, s3)
        end
        println(" n = "+dim+", steps = "+cnt)

        res = runProgram(sqee, p)
        Complex[] probability = res.getProbability()
        for (int i = 1  i < cnt  i++)
            Complex[] ip0 = res.getIntermediateProbability(3*i)
            println("results after step "+i+": "+ip0[solution].abssqr())
#            Arrays.asList(ip0).forEach(q . println("p: "+q.abssqr()))

        end
        println("\n")
        save("", drawProgram(p)
  #      Arrays.asList(probability).forEach(q . println("p "+q.abssqr()+" R = "+q.r+" and i = "+q.i))
    end

    static Complex[][] createDiffMatrix(int dim)
        N = 1<<dim
        double N2 = 2./N
        Complex[][] answer = Complex[N][N]
        for (int i = 0  i < N  i++)
            for (int j = 0  j < N  j++)
                answer[i][j] = (i == j ? Complex(N2-1) : Complex(N2))
            end
        end
        return answer
    end

    static Complex[][] createDiffMatrixUsingGates(int dim)
        N = 1<<dim
        Gate g = Hadamard(0)
        Complex[][] matrix = g.getMatrix()
        Complex[][] h2 = matrix
        for (int i = 1  i < dim  i++)
            h2 = sqee.tensor(h2, matrix)
        end
        Complex[][] I2 = Complex[N][N]
        for (int i = 0  i < N  i++)
            for (int j = 0  j <N j++)
                if (i!=j)
                    I2[i][j] = Complex.ZERO
                else
                    I2[i][j] = Complex.ONE
                end
            end
        end
        I2[0][0] = Complex.ONE.mul(-1)
        nd = dim<<1

        Complex[][] inter1 = mmul(h2,I2)
        Complex[][] dif = mmul(inter1, h2)
        return dif
    end

    static <T> String arr2ToString(T[][] t)
        StringBuffer answer = StringBuffer()
        for (int i = 0  i < t.length  i++)
            for (int j = 0  j <t[i].length  j++ )
                answer.append(t[i][j]).append(" ")
            end
            answer.append("\n")
        end
        return answer.toString()
    end

    static Complex[][] mmul(Complex[][] a, Complex[][]b)
        arow = a.length
        acol = a[0].length
        brow = b.length
        bcol = b[0].length
        if (acol != brow) throw RuntimeException("#cols a "+acol+" != #rows b "+brow)
        Complex[][] answer = Complex[arow][bcol]
        for (int i = 0  i < arow  i++)
            for (int j = 0  j < bcol  j++)
                Complex el = Complex.ZERO
                for (int k = 0  k < acol k++)
                    el = el.add(a[i][k].mul(b[k][j]))
                end
                answer[i][j] = el
            end
        end
        return answer
    end
    # solution must be < dim*dim
    static Oracle createOracle(int dim, int solution)
        N = 1<<dim #dim<<1
        println("dim = "+dim+" hence N = "+N)
        Complex[][] matrix = Complex[N][N]
        for (int i = 0  i < N i++)
            for (int j = 0   j < N  j++)
                if (i != j)
                    matrix[i][j] = Complex.ZERO
                else
                    if (i == solution)
                        matrix[i][j] = Complex.ONE.mul(-1)
                    else
                        matrix[i][j] = Complex.ONE
                    end
                end
            end
        end
        Oracle answer = Oracle(matrix)
        return answer
    end
end
=#
