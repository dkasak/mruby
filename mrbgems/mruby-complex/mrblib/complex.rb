class Complex < Numeric
  def self.polar(abs, arg = 0)
    Complex(abs * Math.cos(arg), abs * Math.sin(arg))
  end

  def inspect
    "(#{to_s})"
  end

  def to_s
    "#{real}#{'+' unless imaginary.negative?}#{imaginary}i"
  end

  def +@
    Complex(real, imaginary)
  end

  def -@
    Complex(-real, -imaginary)
  end

  def +(rhs)
    if rhs.is_a? Complex
      Complex(real + rhs.real, imaginary + rhs.imaginary)
    elsif rhs.is_a? Numeric
      Complex(real + rhs, imaginary)
    end
  end

  def -(rhs)
    if rhs.is_a? Complex
      Complex(real - rhs.real, imaginary - rhs.imaginary)
    elsif rhs.is_a? Numeric
      Complex(real - rhs, imaginary)
    end
  end

  def *(rhs)
    if rhs.is_a? Complex
      Complex(real * rhs.real - imaginary * rhs.imaginary, real * rhs.imaginary + rhs.real * imaginary)
    elsif rhs.is_a? Numeric
      Complex(real * rhs, imaginary * rhs)
    end
  end

  def /(rhs)
    if rhs.is_a? Complex
      div = rhs.real * rhs.real + rhs.imaginary * rhs.imaginary
      Complex((real * rhs.real + imaginary * rhs.imaginary) / div, (rhs.real * imaginary - real * rhs.imaginary) / div)
    elsif rhs.is_a? Numeric
      Complex(real / rhs, imaginary / rhs)
    end
  end
  alias_method :quo, :/

  def ==(rhs)
    if rhs.is_a? Complex
      real == rhs.real && imaginary == rhs.imaginary
    elsif rhs.is_a? Numeric
      imaginary.zero? && real == rhs
    end
  end

  def abs
    Math.sqrt(abs2)
  end
  alias_method :magnitude, :abs

  def abs2
    real * real + imaginary * imaginary
  end

  def arg
    Math.atan2 imaginary, real
  end
  alias_method :angle, :arg
  alias_method :phase, :arg

  def conjugate
    Complex(real, -imaginary)
  end
  alias_method :conj, :conjugate

  def fdiv(numeric)
    Complex(real.to_f / numeric, imaginary.to_f / numeric)
  end

  def polar
    [abs, arg]
  end

  def real?
    false
  end

  def rectangular
    [real, imaginary]
  end
  alias_method :rect, :rectangular

  def to_r
    raise RangeError.new "can't convert #{to_s} into Rational" unless imaginary.zero?
    Rational(real, 1)
  end

  alias_method :imag, :imaginary
end

[Fixnum, Float].each do |cls|
  [:+, :-, :*, :/, :==].each do |op|
    cls.instance_exec do
      original_operator_name = "__original_operator_#{op}_complex"
      alias_method original_operator_name, op
      define_method op do |rhs|
        if rhs.is_a? Complex
          Complex(self).send(op, rhs)
        else
          send(original_operator_name, rhs)
        end
      end
    end
  end
end
