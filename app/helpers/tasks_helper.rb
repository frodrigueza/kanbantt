module TasksHelper

  def real_image(real)
    if real < 8
      '0.png'
    elsif real < 20
      'r1.png'
    elsif real < 33
      'r2.png'
    elsif real < 46
      'r3.png'
    elsif real < 58
      'r4.png'
    elsif real < 71
      'r5.png'
    elsif real < 83
      'r6.png'
    elsif real < 96
      'r7.png'
    else
      'r8.png'
    end
  end

  def expected_image(expected)
    if expected < 8
      '0.png'
    elsif expected < 20
      'e1.png'
    elsif expected < 33
      'e2.png'
    elsif expected < 46
      'e3.png'
    elsif expected < 58
      'e4.png'
    elsif expected < 71
      'e5.png'
    elsif expected < 83
      'e6.png'
    elsif expected < 96
      'e7.png'
    else
      'e8.png'
    end
  end

  # entrga lo que falta de manera formateada, se ocupa en la vista del arbol
  def remaining_days(task)
    if task.progress == 100
      'Finalizada'
    elsif task.remaining < 0
      if task.remaining.abs <= 1
        'Termina hoy'
      elsif (task.remaining.to_i*-1) == 1
        'Atrasada 1 día'        
      else
        'Atrasada '+ (task.remaining.to_i*-1).to_s + ' días'
      end
    elsif task.remaining > 0
      if task.remaining > task.duration_in_date
        if (task.remaining.to_i - task.duration_in_date.to_i + 1) == 1
          'Comienza en 1 día'
        else
         'Comienza en ' + (task.remaining.to_i - task.duration_in_date.to_i + 1).to_s + ' días'
        end
      else
        if task.remaining.to_i == 1
        'Finaliza en 1 día'
        else 
         'Finaliza en ' + (task.remaining.to_i).to_s + ' días'
        end
      end
    end
  end

  def css_task_status_color(task)
    if task.delayed
      'bad'
    else
      'great'
    end
  end

  def progress_or_symbol(t)
    if t.progress.to_i == 100
      '<span class="glyphicon glyphicon-check"></span>'
    else
      '<div class="real_progress ' + started_status(t.in_progress) +'">' + t.info_progress[0].to_s + '% real ' + '</div>'+'<div class="expected_progress">' + t.info_progress[1].to_s + '% esperado </div>'
    end
  end






end
