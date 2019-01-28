"""
A Context object represents all of the information available to a bandit
algorithm when it makes its decisions. This information exceeds the
definition of context used in the bandit literature: it includes, for example,
the number of arms and the current trial number.
"""
abstract type Context end
