if RUBY_VERSION < '1.9' && !defined?(CSV)
  CSV = FasterCSV
end