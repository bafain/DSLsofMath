
deriv :: "some function type" -> "some function type" 
deriv f = ???

+ Attempt 1: pattern matching on "semantic functions"?
+ Attempt 2: using lim and psi?
+ Attempt 3: build a DSL (called FunExp)

* Live coding
DSL for derivatives ={here} a DSL for 1-argument functions (or 1-var. epressions)

Example functions / expressions:

\begin{code}
sq x = x^2
tw x = 2*x
c2 x = 2
psi f x h = (f (x+h) - f x)/h
t1 = psi sq -- leder inte till rätt väg

type REAL = Double

-- Syntax datatype for 1-argument function expressions
data SynF -- TODO

-- Semantic type   for 1-argument function expressions
type SemF = REAL -> REAL
eval :: SynF -> SemF
eval = error "TODO: eval"

deriv :: SynF -> SynF
deriv = error "TODO: deriv"

e1, e2, e3, e4 :: SynF
(e1, e2, e3, e4) = error "TODO: examples"
\end{code}

Each DSL needs
-- type of syntax trees:     Syn
-- type of semantic values:         Sem
-- a function        eval :: Syn -> Sem


\begin{code}
simplify :: SynF -> SynF
simplify = error "Exercise!"
  -- 1*e -> e
  -- 0*e -> 0
  -- 0+e -> e
  -- etc.
\end{code}

