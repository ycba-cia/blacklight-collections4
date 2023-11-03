class Dog
  def initialize(*args, **kwargs, &block)
    self.retrieve ||= puts Cat
  end
end

Dog.new(retrieve: Cat).retrieve