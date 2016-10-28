class Statistic
  def adoptions_by_week(date_from, date_to)
    set_atributes(date_from, date_to)
    while @date_iter < @date_finish
      date_aux = @date_iter
      date_start = date_aux
      date_finish_range = date_aux.next_week.yesterday
      dato = { date_start: date_start, date_finish: date_finish_range }
      adoptions_count = Adoption.search_by_create_date_from(date_start)
                        .search_by_create_date_to(date_finish_range).count
      dato[:adoptions_count] = adoptions_count
      @datos.push(dato)
      @date_iter = date_start.next_week
    end
    @datos
  end

  def entry_by_week(date_from, date_to)
    set_atributes(date_from, date_to)
    while @date_iter < @date_finish
      date_aux = @date_iter
      date_start = date_aux
      date_finish_range = date_aux.next_week.yesterday
      dato = { date_start: date_start, date_finish:  date_finish_range }
      entry_count = Animal.search_by_type('Adoptable').search_by_admission_date_from(date_start)
                    .search_by_admission_date_to(date_finish_range).count
      dato[:entry_count] = entry_count
      @datos.push(dato)
      @date_iter = date_start.next_week
    end
    @datos
  end

  def set_atributes(date_f, date_to)
    date_to.nil? ? @date_finish = Date.today : @date_finish = Date.parse(date_to)
    date_f.nil? ? @date_iter = date_finish.months_ago(3).beginning_of_week : @date_iter = Date.parse(date_f).beginning_of_week
    @datos = []
  end
end
