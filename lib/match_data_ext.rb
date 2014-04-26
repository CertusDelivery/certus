class MatchData
  def to_hash
    Hash[self.names.zip(self.captures)]
  end
end
