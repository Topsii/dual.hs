{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Control.Category.Dual where

import Prelude (Eq, Ord, Read, Show, Bounded, ($))

import Control.Category
import Data.Functor.Classes
import Data.Semigroup (Semigroup)
import Data.Monoid (Monoid)

newtype Dual k a b = Dual { dual :: k b a }
  deriving (Eq, Ord, Read, Show, Bounded, Semigroup, Monoid)

instance Category k => Category (Dual k) where
    id = Dual id
    Dual f . Dual g = Dual (g . f)

instance Eq2 k => Eq2 (Dual k) where liftEq2 f g (Dual x) (Dual y) = liftEq2 g f x y
instance Ord2 k => Ord2 (Dual k) where liftCompare2 f g (Dual x) (Dual y) = liftCompare2 g f x y

instance Read2 k => Read2 (Dual k) where
    liftReadsPrec2 arp arl brp brl =
        readsData $ readsUnaryWith (liftReadsPrec2 brp brl arp arl) "Dual" Dual

instance Show2 k => Show2 (Dual k) where
    liftShowsPrec2 asp asl bsp bsl n =
        showsUnaryWith (liftShowsPrec2 bsp bsl asp asl) "Dual" n . dual
