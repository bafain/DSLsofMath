Continuing on from Week 4.

\begin{code}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RebindableSyntax #-}
module Live_5_1a_2020 where
import DSLsofMath.FunExp
import DSLsofMath.FunExpInst ()
import DSLsofMath.Simplify
import qualified Prelude
import Prelude (Eq, Show, id, map, Int, Integer, iterate, take)
import DSLsofMath.Algebra
\end{code}


\begin{code}
newtype FD a = FD (a->a, a->a)   -- Function + Derivative
newtype Bi a = Bi (a, a)         -- Position + Speed
  deriving (Eq, Show)

-- forall c. H2(applyFD c, mulFD, mulBi)
applyFD :: a -> FD a -> Bi a
applyFD c (FD (f, f')) = Bi (f c, f' c)

fd1 :: Ring a => FD a
fd1 = FD (\x -> (x-1)^+2, \x -> 2*(x-1))

xFD :: Ring a => FD a
xFD = FD (id, one)

e2 :: Ring a => a -> a
e2 x = (x-1)^+2

e2FD :: Ring a => FD a
e2FD = e2 xFD

test2 :: Ring a => a -> Bi a
test2 c = applyFD c e2FD

list2 :: Ring a => [Bi a]
list2 = map test2 (countUp 4 zero)

testSyn = map simpBi list2

countUp :: Ring a => Int -> a -> [a]
countUp steps start = take steps (iterate (one+) start)

idBi :: Ring a => a -> Bi a
idBi c = Bi (c, one)

instance Additive a   => Additive (FD a) where  (+) = addFD;  zero = zeroFD
instance Ring a => Multiplicative (FD a) where  (*) = mulFD;  one = oneFD
instance AddGroup a   => AddGroup (FD a) where  negate = negateFD

addFD :: Additive a => FD a -> FD a -> FD a
addFD (FD (f, f')) (FD (g, g')) = FD (f+g, f'+g')

zeroFD :: Additive a => FD a
zeroFD = FD (zero, zero)

oneFD :: Ring a => FD a
oneFD = FD (one, zero)

mulFD :: Ring a => FD a -> FD a -> FD a
mulFD (FD (f, f')) (FD (g, g')) = FD (f*g, f*g' + f'*g)

-- unary minus
negateFD :: AddGroup a => FD a -> FD a
negateFD (FD (f, f')) = FD (negate f, negate f')
\end{code}

The same for |Bi|.
\begin{code}
instance Additive a   => Additive (Bi a) where  (+) = addBi;  zero = zeroBi
instance Ring a => Multiplicative (Bi a) where  (*) = mulBi;  one = oneBi
instance AddGroup a   => AddGroup (Bi a) where  negate = negateBi


-- Spec.: forall c. H2(applyFD c, mulFD, mulBi)
mulBi :: Ring a => Bi a -> Bi a -> Bi a
mulBi (Bi (f,f')) (Bi (g,g')) = Bi (f*g, f*g' + f'*g)

addBi :: Additive a => Bi a -> Bi a -> Bi a
addBi (Bi (f,f')) (Bi (g,g')) = Bi (f+g, f'+g')

negateBi :: AddGroup a => Bi a -> Bi a
negateBi (Bi (f,f')) = Bi (negate f, negate f')

zeroBi :: Additive a => Bi a
zeroBi = Bi (zero, zero)

oneBi :: Ring a => Bi a
oneBi = Bi (one, zero)
\end{code}

H2(applyFD c, mulFD, mulBi)
forall fd1, fd2. applyFD c (mulFD fd1 fd2) == mulBi (applyFD c fd1) (applyFD c fd2)
-- steg 1: expandera fd1 = FD (f, f') och fd2 = FD (g, g')
  mulBi (applyFD c fd1) (applyFD c fd2)
== -- expandera fd1, fd2
  mulBi (applyFD c (FD (f, f'))) (applyFD c (FD (g, g')))
== -- def. av applyFD
  mulBi (Bi (f c, f' c)) (Bi (g c, g' c))
== -- nya namn x = f c, x' = f' x, y = g c, y' g' c
  mulBi (Bi (x, x')) (Bi (y, y'))
== -- Sista steget: definiera mulBI så att detta gäller
  Bi (x*y, x*y' + x'*y)
== -- nya namn enligt ovan
  Bi ((f c)*(g c), (f c)*(g' c) + (f' c)*(g c))
== -- def. (*), (+) för funktioner
  Bi ((f*g) c, (f*g' + f'*g) c)
== -- def. av applyFD
  applyFD c (FD (f*g, f*g' + f'*g))
== -- def. mulFD
  applyFD c (mulFD (FD (f, f') (g, g'))
== -- exp.
  applyFD c (mulFD fd1 fd2)


\begin{code}
instance Field a      => MulGroup (FD a) where  recip = recipFD
instance Field a      => MulGroup (Bi a) where  recip = recipBi

recipFD :: Field a => FD a -> FD a
recipFD (FD (f, f')) = let rf = recip f in FD (rf, negate (rf*rf) * f')

recipBi :: Field a => Bi a -> Bi a
recipBi (Bi (f, f')) = let rf = recip f in Bi (rf, negate (rf*rf) * f')

----------------

xBi :: Ring a => a -> Bi a
xBi x = Bi (x, 1)

simpBi :: Bi FunExp -> Bi FunExp
simpBi (Bi (f, f')) = Bi (simplify f, simplify f')
\end{code}
