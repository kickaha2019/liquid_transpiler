require 'date'
require 'uri'

module TranspiledMethods
  EMPTY_METHOD = 'empty?'.to_sym

  def f_abs( value)
    if value.nil?
      return nil
    elsif value.is_a?( String)
      if /[\.]/ =~ value
        value = value.to_f
      else
        value = value.to_i
      end
    end
    value.abs
  end

  def f_append( value, postfix)
    value.nil? ? postfix : (postfix.nil? ? value : (value.to_s + postfix.to_s))
  end

  def f_at_least( value, limit)
    return nil if value.nil?
    (value < limit) ? limit : value
  end

  def f_at_most( value, limit)
    return nil if value.nil?
    (value < limit) ? value : limit
  end

  def f_capitalize( value)
    value.nil? ? nil : value.capitalize
  end

  def f_ceil( value)
    value.nil? ? nil : value.to_f.ceil
  end

  def f_compact( map)
    [].tap do |result|
      map.each {|entry| result << entry if entry}
    end
  end

  def f_concat( map1, map2)
    [].tap do |result|
      map1.each {|entry| result << entry}
      map2.each {|entry| result << entry}
    end
  end

  def f_date( date, format)
    if date.is_a?( String)
      case date
      when 'now'
        date = Date::today
      when 'today'
        date = Date::today
      else
        date = Date.parse( date)
      end
    end

    date.strftime( format)
  end

  def f_default( value, defval, params={})
    return value if params['allow_false'] && (value == false)
    return defval if value.respond_to?( EMPTY_METHOD) && value.empty?
    value ? value : defval
  end

  def f_divided_by( value, *args)
    if args[0].is_a?( Integer)
      (value / args[0]).floor
    else
      value / args[0]
    end
  end

  def f_downcase( value)
    value.nil? ? nil : value.downcase
  end

  def f_escape( value)
    return nil if value.nil?
    value.gsub( /['&"<>]/) do |letter|
      case letter
      when '"'
        '&quot;'
      when '<'
        '&lt;'
      when '>'
        '&gt;'
      when "'"
        '&#39;'
      when '&'
        '&amp;'
      end
    end
  end

  def f_escape_once( value)
    return nil if value.nil?

    fragments, offset = [], 0
    while offset < value.size
      if m = value.match( /(&([a-z]+|#\d+);)/i, offset)
        fragments << f_escape( value[offset...m.begin(0)])
        fragments << m[1]
        offset    = m.end(0)
      else
        fragments << f_escape( value[offset..-1])
        break
      end
    end

    fragments.join('')
  end

  def f_first( list)
    return list[0] if list.is_a?( Array)
    list.each do |entry|
      return entry
    end
    nil
  end

  def f_floor( value)
    if value.is_a?( String)
      value = value.to_f
    end
    value.floor
  end

  def f_join( map, separator)
    [].tap do |result|
      map.each {|entry| result << entry}
    end.join(separator)
  end

  def f_last( list)
    return list[-1] if list.is_a?( Array)
    last = nil
    list.each do |entry|
      last = entry
    end
    last
  end

  def f_lstrip( value)
    value.lstrip
  end

  def f_minus( left, right)
    left - right
  end

  def f_modulo( left, right)
    left % right
  end

  def f_map( map, field)
    [].tap do |result|
      map.each {|entry| result << x(entry,field)}
    end
  end

  def f_newline_to_br( value)
    value.gsub( "\n", "<br />\n")
  end

  def f_plus( left, right)
    left + right
  end

  def f_prepend( value, prefix)
    prefix.to_s + value
  end

  def f_remove( value, elide)
    value.gsub( elide, '')
  end

  def f_remove_first( value, elide)
    value.sub( elide, '')
  end

  def f_replace( value, was, now)
    value.gsub( was, now)
  end

  def f_replace_first( value, was, now)
    value.sub( was, now)
  end

  def f_reverse( list)
    list.reverse
  end

  def f_round( value, places=0)
    value.round( places)
  end

  def f_rstrip( value)
    value.rstrip
  end

  def f_size( list)
    list.size
  end

  def f_slice( list, start, length=1)
    start = list.size + start if start < 0
    if list.is_a?( String)
      list[start...(start+length)]
    else
      list[start...(start+length)].join('')
    end
  end

  def f_sort( list, sort_by=nil)
    if sort_by
      list.sort_by {|entry| x(entry,sort_by)}
    else
      list.sort
    end
  end

  def f_sort_natural( list, sort_by=nil)
    if sort_by
      list.sort_by {|entry| x(entry,sort_by).downcase}
    else
      list.sort_by {|entry| entry.downcase}
    end
  end

  def f_split( value, *args)
    value.split( args[0])
  end

  def f_strip( value)
    value.strip
  end

  def f_strip_html( value)
    value.gsub( /<[^>]*>/, '')
  end

  def f_strip_newlines( value)
    value.gsub( "\n", '')
  end

  def f_sum( list, sum_by=nil)
    if sum_by
      list.inject(0) {|r,e| r + x(e,sum_by)}
    else
      list.inject(:+)
    end
  end

  def f_times( value, *args)
    value * args[0]
  end

  def o_eq( left, right)
    return false if left.nil? || right.nil?
    left == right
  end

  def t( thing)
    thing.to_s
  end

  def x( thing, field)
    if thing.is_a?( Hash)
      thing[field]
    else
      thing.send( field.to_sym)
    end
  end
end
