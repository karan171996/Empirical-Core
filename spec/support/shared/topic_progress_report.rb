shared_context 'Topic Progress Report' do
  # Stats should come out like this:
  # name,     student_count,    proficient_count,   not_proficient_count,
  # 1st Grade CCSS,  3,                2,                  1
  # 2nd Grade CCSS,  2,                1,                  1

  # hidden_topic should never be displayed
  # When filtered by empty_classroom, nothing displays
  # when filtered by empty_unit, nothing displays
  # When filtered by unassigned student, nothing displays
  let!(:section) { create(:section) }
  let!(:full_classroom) { create(:classroom, name: "full") }
  let!(:teacher) {full_classroom.owner}
  let!(:alice) { create(:student, name: 'Alice Cool', classrooms: [full_classroom]) }
  let!(:fred) { create(:student, name: "Fred Kewl", classrooms: [full_classroom]) }
  let!(:zojirushi) { create(:student, name: "Zojirushi Kewel", classrooms: [full_classroom]) }
  let!(:unassigned_student) { create(:student, classrooms: []) }
  let!(:second_grade_topic) { create(:topic, section: section, name: "2nd Grade CCSS") }
  let!(:first_grade_topic) { create(:topic, section: section, name: "1st Grade CCSS") }
  let!(:hidden_topic) { create(:topic, section: section) }
  let!(:empty_classroom) { create(:classroom, :with_no_teacher, visible: false) }
  let!(:empty_classrooms_teacher) {create(:classrooms_teacher, classroom: empty_classroom, user: teacher)}
  let!(:unit1) { create(:unit, user_id: teacher.id) }
  let!(:empty_unit) { create(:unit, user_id: teacher.id) }
  let!(:activity_for_second_grade_topic) { create(:activity,
    name: '2nd Grade Activity', topic: second_grade_topic) }
  let!(:classroom_activity1) { create(:classroom_activity,
                                            classroom: full_classroom,
                                            activity: activity_for_second_grade_topic,
                                            assign_on_join: true,
                                            unit: unit1) }
  let!(:activity_for_first_grade_topic) { create(:activity,
    name: '1st Grade Activity', topic: first_grade_topic) }
  let!(:classroom_activity2) { create(:classroom_activity,
                                            classroom: full_classroom,
                                            activity: activity_for_first_grade_topic,
                                            assign_on_join: true,
                                            unit: unit1) }

  # NOTE: ClassroomActivity.create does not create new activity sessions for every student in the classroom.
  # Create new sessions for them
  let!(:alice_second_grade_topic_session) do
    session = ActivitySession.create(user_id: alice.id, activity: activity_for_second_grade_topic, classroom_activity: classroom_activity1, state: 'finished', percentage: 1, completed_at: 1.month.ago)
    session
  end

  let!(:fred_second_grade_topic_session) do
    session = ActivitySession.create(user_id: fred.id, activity: activity_for_second_grade_topic, classroom_activity: classroom_activity1, state: 'finished', percentage: 1, completed_at: 1.month.ago)
    session
  end

  let!(:zojirushi_second_grade_topic_session) do
    session = ActivitySession.create(user_id: zojirushi.id, activity: activity_for_second_grade_topic, classroom_activity: classroom_activity1, state: 'finished', percentage: 0.49, completed_at: 25.days.ago)
    session
  end

  let!(:alice_first_grade_topic_session)  do
    session = ActivitySession.create(user_id: alice.id, activity: activity_for_first_grade_topic, classroom_activity: classroom_activity2, state: 'finished', percentage: 0.70, completed_at: 28.days.ago)
    session
  end

  let!(:fred_first_grade_topic_session) do
    session = ActivitySession.create(user_id: fred.id, activity: activity_for_first_grade_topic, classroom_activity: classroom_activity2, state: 'finished', percentage: 0.70, completed_at: 2.days.ago)
    session
  end

  let!(:visible_topics) { [first_grade_topic, second_grade_topic] }
  let!(:visible_classrooms) { [full_classroom] }
  let!(:visible_students) { [alice, fred, zojirushi] }
  let!(:visible_activity_sessions) { [
    alice_second_grade_topic_session,
    alice_first_grade_topic_session,
    fred_second_grade_topic_session,
    fred_first_grade_topic_session,
    zojirushi_second_grade_topic_session
  ] }

  let(:best_activity_sessions) { visible_activity_sessions }

  let(:proficient_students) { [alice, fred] }

  let(:not_proficient_students) { [zojirushi] }

  let!(:first_grade_topic_students) { [alice, fred] }

  let(:worst_score_session) { zojirushi_second_grade_topic_session }

  let(:best_score_sessions) { [alice_second_grade_topic_session, fred_second_grade_topic_session] }
end
