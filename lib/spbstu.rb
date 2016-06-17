require 'open-uri'
require 'nokogiri'
require 'roo'
time1 = Time.now
@spbstu = University.find_or_create_by(:name => "СПбПУ")
@version = @spbstu.current_version
@spbstu.current_version += 1
@spbstu.save
spbstu_url = 'http://www.spbstu.ru'
url = 'http://www.spbstu.ru/sveden/common/'
html = open(url)
doc = Nokogiri::HTML(html)
fullname = doc.search('div#found_date p')[-1].text.split("в ")[-1].strip.delete(".")
fullname[0] = fullname[0].mb_chars.upcase.to_s
founder_name = "Министерство образования и науки Российской Федерации"
names = doc.search('[itemprop="fullnameUchred"]').text.strip.delete(" ").split(/(?=[А-Я])/)
founder_director =  "#{names[-3]} #{names[-2]} #{names[-1]}"
founder_address = doc.search('[itemprop="addressUchred"]').text.strip
founder_phone = doc.search('[itemprop="telUchred"]').text.strip.split(':')[1]
founder_email = doc.search('[itemprop="mailUchred"] a').text
founder_site = doc.search('[itemprop="websiteUchred"] a').text
address = doc.search('[itemprop="Address"]').text.split(':')[1].strip
worktime = doc.search('[itemprop="WorkTime"]').text.delete("\n").delete("\t")
dates = doc.search('[itemprop="RegDate"]').text.split(" ")
regdate = "#{dates[2]} #{dates[3]} #{dates[4]} #{dates[5]}"
telephone = doc.search('[itemprop="Telephone"]').text.strip
email = doc.search('[itemprop="E-mail"]').text.strip
spbstuInfo = UniversityInfo.find_or_create_by(university: @spbstu, address: address,
email: email, fullname: fullname, regdate: regdate, site: spbstu_url, telephone: telephone, worktime: worktime,
founder_address: founder_address, founder_email: founder_email, founder_name: founder_name,
founder_phone: founder_phone, founder_site: founder_site, founder_director: founder_director, version: @version)
spbstuInfo.infodate = Time.now
spbstuInfo.version = @version + 1
spbstuInfo.save

def self.create_document(code, doc_link, doc_name, info)
  file = open(doc_link)
  file_ext = doc_link.to_s.split('.').last
  Document.create(university: @spbstu, code: code, date: Time.now, file: file, file_ext: file_ext, fullname: doc_name, info: info, version: @version + 1)
  file.close
end

url = 'http://www.spbstu.ru/sveden/struct/'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.search('div#content_page tbody tr')
link.each do |l|
  fio = l.search('[itemprop="Fio"]')
  break if fio.text.strip.empty?
  name = l.search('[itemprop="Name"]').text.strip
  address = l.search('[itemprop="AddressStr"]').text.strip
  address = nil if address == ""
  site = l.search('[itemprop="Site"]').text.strip
  site = nil if site == ""
  email = l.search('[itemprop="E-mail"]').text.strip
  email = nil if email == ""
  d = Department.find_or_create_by(university: @spbstu, name: name, site: site, email: email, address: address, version: @version, info: "Орган управления")
  d.version = @version + 1
  d.access_date = Time.now
  d.save
  person = Person.find_or_create_by(lastname: fio.text.split(" ")[0], name: fio.text.split(" ")[1], middlename: fio.text.split(" ")[2], version: @version)
  person.version = @version + 1
  person.access_date = Time.now
  person.save
  Post.find_or_create_by(is_manage: true, name: "Руководитель", person: person, placeable_type: d.class.name, placeable_id: d.id)
end
#документы
url = 'http://www.spbstu.ru/sveden/document/'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.search('[itemprop="Ustav_DocLink"] a').attr('href').value
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Ustav_DocLink"] a').text.strip
create_document("Ustav", doc_link, doc_name, "Устав образовательной организации")
link = doc.search('[itemprop="License_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="License_DocLink"] a')[0].text.strip
create_document("Licen", doc_link, doc_name, "Лицензия на осуществление образовательной деятельности")
(1..2).each do |i|
  link = doc.search('[itemprop="License_DocLink"] a')[i].attr('href')
  doc_link = spbstu_url + link
  doc_name = doc.search('[itemprop="License_DocLink"] a')[i].text.strip
  create_document("Pril_Licen", doc_link, doc_name, "Приложение к лицензии на осуществление образовательной деятельности")
end
link = doc.search('[itemprop="Accreditation_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Accreditation_DocLink"] a')[0].text.strip
create_document("Аkkr", doc_link, doc_name, "Свидетельство о государственной аккредитации")
(1..3).each do |i|
  link = doc.search('[itemprop="Accreditation_DocLink"] a')[i].attr('href')
  doc_link = spbstu_url + link
  doc_name = doc.search('[itemprop="Accreditation_DocLink"] a')[i].text.strip
  create_document("Pril_akkred", doc_link, doc_name, "Приложение к свидетельству о государственной аккредитации")
end
link = doc.search('[itemprop="FinPlan_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="FinPlan_DocLink"] a')[0].text.strip
create_document("Plan_FHD", doc_link, doc_name, "План финансово-хозяйственной деятельности образовательной организации, утверждённый в установленном законодательством Российской Федерации порядке, или бюджетные сметы образовательной организации")
link = doc.search('[itemprop="Priem_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Priem_DocLink"] a')[0].text.strip
create_document("Pravila_priema", doc_link, doc_name, "Правила приёма поступающих")
link = doc.search('[itemprop="Mode_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Mode_DocLink"] a')[0].text.strip
create_document("Rezhim_zanyat", doc_link, doc_name, "Режим занятий обучающихся")
link = doc.search('[itemprop="Tek_kontrol_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Tek_kontrol_DocLink"] a')[0].text.strip
create_document("Formi_sroki_kontrolya", doc_link, doc_name, "Формы, периодичность и порядок текущего контроля успеваемости и промежуточной аттестации обучающихся")
link = doc.search('[itemprop="Perevod_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Perevod_DocLink"] a')[0].text.strip
create_document("Perevod", doc_link, doc_name, "Порядок и основания перевода, отчисления и восстановления обучающихся")
link = doc.search('[itemprop="Voz_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Voz_DocLink"] a')[0].text.strip
create_document("Otnoshenie", doc_link, doc_name, "Порядок оформления возникновения, приостановления и прекращения отношений между образовательной организацией и обучающимися и (или) родителями (законными представителями) несовершеннолетних обучающихся")
link = doc.search('[itemprop="LocalActStud"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="LocalActStud"] a')[0].text.strip
create_document("Pravila_rasporyadka", doc_link, doc_name, "Правила внутреннего распорядка обучающихся")
link = doc.search('[itemprop="LocalActOrder"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="LocalActOrder"] a')[0].text.strip
create_document("Pravila_trud_rasporyadka", doc_link, doc_name, "Правила внутреннего трудового распорядка")
link = doc.search('[itemprop="LocalActCollec"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="LocalActCollec"] a')[0].text.strip
create_document("Kol_dorovor", doc_link, doc_name, "Коллективный договор")
link = doc.search('[itemprop="LocalActObSt"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="LocalActObSt"] a')[0].text.strip
create_document("Poryadok_oplatu_za_progivanie", doc_link, doc_name, "Локальные нормативные акты, определяющие размер платы за пользование жилым помещением и коммунальные услуги в общежитии для обучающихся, принимаемых с учетом мнения советов обучающихся и представительных органов обучающихся в организации, осуществляющей образовательную деятельность")
link = doc.search('[itemprop="PaidEdu_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="PaidEdu_DocLink"] a')[0].text.strip
create_document("Poryadok_platn_uslug", doc_link, doc_name, "Порядок оказания платных образовательных услуг")
link = doc.search('[itemprop="PaidEdu_DocLink"] a')[1].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="PaidEdu_DocLink"] a')[1].text.strip
create_document("Stoimost_obuch", doc_link, doc_name, "Документ об утверждении стоимости обучения по каждой образовательной программе")
link = doc.search('[itemprop="PaidEdu_DocLink"] a')[2].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="PaidEdu_DocLink"] a')[2].text.strip
create_document("Dogovor_platn_obraz_uslug", doc_link, doc_name, "Образец договора об оказании платных образовательных услуг")
link = doc.search('[itemprop="Prescription_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Prescription_DocLink"] a')[0].text.strip
create_document("Predpisaniya", doc_link, doc_name, "Предписания органов, осуществляющих государственный контроль (надзор) в сфере образования")
link = doc.search('[itemprop="Prescription_Otchet_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="Prescription_Otchet_DocLink"] a')[0].text.strip
create_document("Otchet_predpisaniya", doc_link, doc_name, "Отчёты об исполнении предписаний органов, осуществляющих государственный контроль (надзор) в сфере образования")
link = doc.search('[itemprop="ReportEdu_DocLink"] a')[0].attr('href')
doc_link = spbstu_url + link
doc_name = doc.search('[itemprop="ReportEdu_DocLink"] a')[0].text.strip
create_document("Othet_o_samoobsledovanii", doc_link, doc_name, "Отчет о результатах самообследования")
#программы
url = 'http://www.spbstu.ru/sveden/education'
html = open(url)
doc = Nokogiri::HTML(html)
doc2 = doc.search('div.table-responsive table.footable tbody tr[itemtype="vpo"]')
doc2.each do |d|
  name = d.search('td')[0].children[0].text.strip.delete("\n")
  code =  d.search('[itemprop="EduCode"]').text.strip
  level = d.search('[itemprop="EduLavel"]').text.strip
  date = d.search('[itemprop="DateEnd"]').text.strip
  (0..2).each do |i|
    term = d.search('td[itemprop="LearningTerm"]')[i].text.strip.split("\n\t\t\t")
    if term[0].strip != "-"
      apprent = term[0].strip
      form = term[1].strip
      prog = Program.find_or_create_by(university: @spbstu, apprent: apprent, code: code, date: date, level: level, form: form, name: name, version: @version)
      prog.version = @version + 1
      prog.save
    end
  end
end
#руководство
url = 'http://www.spbstu.ru/sveden/employees/'
html = open(url)
doc = Nokogiri::HTML(html)
doc2 = doc.search('div#content_page tbody tr')
doc2.each do |d|
  fio = d.search('[itemprop="fio"]').text.strip.split
  post = d.search('[itemprop="post"]').text.strip
  telephone = d.search('[itemprop="Telephone"]').text.strip
  email = d.search('[itemprop="e-mail"]').text.strip
  person = Person.find_or_create_by(lastname: fio[0], name: fio[1], middlename: fio[2], phone: telephone, email: email, version: @version)
  person.version = @version + 1
  person.save
  Post.find_or_create_by(is_manage: true, name: post, person: person, placeable_type: @spbstu.class.name, placeable_id: @spbstu.id)
end
#преподаватели
(2..2917).each do |i|
  fio = xlsx.cell(i, 'A').split
  post_name = xlsx.cell(i, 'B')
  rank = xlsx.cell(i, 'D')
  degree = xlsx.cell(i, 'C')
  lastname = fio[0]
  name = fio[1]
  fio.delete_at(0)
  fio.delete_at(0)
  middlename = fio.join(" ") if fio.present?
  person = Person.find_or_create_by(lastname: lastname, name: name, middlename: middlename, rank: rank, degree: degree, version: @version)
  person.version = @version + 1
  person.access_date = Time.now
  person.save
  Post.find_or_create_by(is_manage: false, placeable_type: @spbstu.class.name, placeable_id: @spbstu.id, person: person, name: post_name)
end

time2 = Time.now - time1
puts "Время работы программы: " + "#{time2.round(1)}" + " секунд"
