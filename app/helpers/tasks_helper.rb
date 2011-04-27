module TasksHelper

  def status_str(stat)
    case(stat)
      when Task::Status::NEW then 'Nueva'
      when Task::Status::ACCEPTED then 'Aceptada'
      when Task::Status::REJECTED then 'Rechazada'
      when Task::Status::IN_PROGRESS then 'En progreso'
      when Task::Status::FINISHED then 'Finalizada'
    end
  end

end
