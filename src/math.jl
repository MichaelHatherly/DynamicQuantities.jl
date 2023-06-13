Base.:*(l::Dimensions, r::Dimensions) = @map_dimensions(+, l, r)
Base.:*(l::Quantity, r::Quantity) = Quantity(l.value * r.value, l.dimensions * r.dimensions)
Base.:*(l::Quantity, r::Dimensions) = Quantity(l.value, l.dimensions * r)
Base.:*(l::Dimensions, r::Quantity) = Quantity(r.value, l * r.dimensions)
Base.:*(l::Quantity, r) = Quantity(l.value * r, l.dimensions)
Base.:*(l, r::Quantity) = Quantity(l * r.value, r.dimensions)
Base.:*(l::Dimensions, r) = Quantity(r, l)
Base.:*(l, r::Dimensions) = Quantity(l, r)

Base.:/(l::Dimensions, r::Dimensions) = @map_dimensions(-, l, r)
Base.:/(l::Quantity, r::Quantity) = Quantity(l.value / r.value, l.dimensions / r.dimensions)
Base.:/(l::Quantity, r::Dimensions) = Quantity(l.value, l.dimensions / r)
Base.:/(l::Dimensions, r::Quantity) = Quantity(inv(r.value), l / r.dimensions)
Base.:/(l::Quantity, r) = Quantity(l.value / r, l.dimensions)
Base.:/(l, r::Quantity) = l * inv(r)
Base.:/(l::Dimensions, r) = Quantity(inv(r), l)
Base.:/(l, r::Dimensions) = Quantity(l, inv(r))

Base.:+(l::Quantity, r::Quantity) = dimension(l) == dimension(r) ? Quantity(l.value + r.value, l.dimensions) : throw(DimensionError(l, r))
Base.:-(l::Quantity) = Quantity(-l.value, l.dimensions)
Base.:-(l::Quantity, r::Quantity) = l + (-r)

Base.:+(l::Quantity, r) = dimension(l) == dimension(r) ? Quantity(l.value + r, l.dimensions) : throw(DimensionError(l, r))
Base.:+(l, r::Quantity) = dimension(l) == dimension(r) ? Quantity(l + r.value, r.dimensions) : throw(DimensionError(l, r))
Base.:-(l::Quantity, r) = l + (-r)
Base.:-(l, r::Quantity) = l + (-r)

_pow(l::Dimensions, r) = @map_dimensions(Base.Fix1(*, r), l)
_pow(l::Quantity{T}, r) where {T} = Quantity(l.value^r, _pow(l.dimensions, r))
_pow_as_T(l::Quantity{T}, r) where {T} = Quantity(l.value^convert(T, r), _pow(l.dimensions, r))
Base.:^(l::Dimensions{R}, r::Integer) where {R} = _pow(l, r)
Base.:^(l::Dimensions{R}, r::Number) where {R} = _pow(l, tryrationalize(R, r))
Base.:^(l::Quantity{T,R}, r::Integer) where {T,R} = _pow(l, r)
Base.:^(l::Quantity{T,R}, r::Number) where {T,R} = _pow_as_T(l, tryrationalize(R, r))

Base.inv(d::Dimensions) = @map_dimensions(-, d)
Base.inv(q::Quantity) = Quantity(inv(q.value), inv(q.dimensions))

Base.sqrt(d::Dimensions{R}) where {R} = d^inv(convert(R, 2))
Base.sqrt(q::Quantity) = Quantity(sqrt(q.value), sqrt(q.dimensions))
Base.cbrt(d::Dimensions{R}) where {R} = d^inv(convert(R, 3))
Base.cbrt(q::Quantity) = Quantity(cbrt(q.value), cbrt(q.dimensions))

Base.abs(q::Quantity) = Quantity(abs(q.value), q.dimensions)
