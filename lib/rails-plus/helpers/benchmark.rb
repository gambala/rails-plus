module RailsPlus::Helpers::Benchmark
  def benchmark(caption = nil, &block)
    Benchmark.benchmark(caption.to_s) { |x| x.report { yield } }
  end
end
