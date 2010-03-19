module StudentHelper
  def observe_fields(fields, options)
	  #prepare a value of the :with parameter
	  with = ""
	  for field in fields
		  with += "'"
		  with += "&" if field != fields.first
		  with += field + "='+escape($('" + field + "').value)"
		  with += " + " if field != fields.last
	  end

	  #generate a call of the observer_field helper for each field
	  ret = "";
	  for field in fields
		  ret += observe_field(field,	options.merge( { :with => with }))
	  end
	  ret
  end
end
