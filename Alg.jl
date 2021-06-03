include("Graph.jl")

using LinearAlgebra

function getLp(G)
    L = zeros(G.n, G.n)
    for (ID, u, v, w) in G.E
        L[u, u] += w
        L[v, v] += w
        L[u, v] -= w
        L[v, u] -= w
    end
    L .+= (1 / G.n)
    Lp = inv(L)
    Lp .-= (1 / G.n)

    return Lp
end

function findD(G)
    Lp = getLp(G)
    d = 0.0
    for i = 1 : G.n, j = i+1 : G.n
        td = Lp[i, i] + Lp[j, j] - 2*Lp[i, j]
        d = max(d, td)
    end
    return d
end

function findd(G)
    g = Array{Array{Int32, 1}, 1}(undef, G.n)
    foreach(i -> g[i] = [], 1 : G.n)
    for (ID, u, v, w) in G.E
        push!(g[u], v)
        push!(g[v], u)
    end
    ret = 0
    d = zeros(Int32, G.n)
    Q = zeros(Int32, G.n+10)
    for s = 1 : G.n
        d .= -1
        d[s] = 0
        front = 1
        rear = 1
        Q[1] = s

        while front <= rear
            v = Q[front]
            front += 1
            for w in g[v]
                if d[w] < 0
                    rear += 1
                    Q[rear] = w
                    d[w] = d[v] + 1
                end
            end
        end

        ret = max(ret, d[argmax(d)])
    end

    return ret
end
