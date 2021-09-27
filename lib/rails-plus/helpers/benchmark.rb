module RailsPlus::Helpers::Benchmark
  def benchmark(caption = '', &block)
    Benchmark.benchmark(caption) { |x| x.report { yield } }
  end
end
