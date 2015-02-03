module TestStochasticBandit
    using Bandits, Distributions
    using Base.Test

    @test isa(StochasticBandit, DataType)
    @test !StochasticBandit.abstract

    bdt = StochasticBandit([Bernoulli(0.1), Bernoulli(0.2)])
    ctxt = MinimalContext(1)

    @test count_arms(bdt, ctxt) == 2

    @test regret(bdt, ctxt, 1) == 0.1
    @test regret(bdt, ctxt, 2) == 0.0

    m1 = 0.0
    m2 = 0.0
    for n in 1:10_000
        d = draw(bdt, ctxt, 1)
        @test d == 0 || d == 1
        m1 = (1 - 1 / n) * m1 + (1 / n) * d

        d = draw(bdt, ctxt, 2)
        @test d == 0 || d == 1
        m2 = (1 - 1 / n) * m2 + (1 / n) * d
    end

    @test abs(m1 - 0.1) < 0.1
    @test abs(m2 - 0.2) < 0.1
end
