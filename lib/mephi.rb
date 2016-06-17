require 'open-uri'
require 'nokogiri'
require 'open_uri_redirections'
time1 = Time.now
mephi_url = 'https://mephi.ru'
url = 'https://mephi.ru/about/govrn-state/index.php'
html = open(url)
doc = Nokogiri::HTML(html)
@mephi = University.find_or_create_by(:name => "НИЯУ МИФИ")
@version = @mephi.current_version
@mephi.current_version += 1
@mephi.save
mephi_table = doc.css('.table-index').css('td')
address = mephi_table[15].text
email = mephi_table[31].text
fullname = mephi_table[3].text
infodate = Date.today
regdate = mephi_table[13].text
telephone = mephi_table[27].text
founder_table = doc.css('table')[4].css('table')[3].css('td')
founder_address = founder_table[3].text
founder_email = founder_table[11].text
founder_name = founder_table[1].text
founder_phone = founder_table[7].text.delete("\n").delete(' ')
founder_site = founder_table[9].text
mephiInfo = UniversityInfo.find_or_create_by(university: @mephi, address: address,
email: email, fullname: fullname, regdate: regdate, site: mephi_url, telephone: telephone,
founder_address: founder_address, founder_email: founder_email, founder_name: founder_name,
founder_phone: founder_phone, founder_site: founder_site, version: @version)
mephiInfo.infodate = Date.today
mephiInfo.version = @version + 1
mephiInfo.save

def self.create_programs(url)
  html = open(url)
  doc = Nokogiri::HTML(html)
  link = doc.css('table[style = "border-collapse:collapse;"]')
  class_name = link.attr("class").value[0..-4]
  link2 = link.css('td')
  model = nil
  description = nil
  file1 = nil
  code = name = level = date = form = apprent = profile = nil
  link2.each do |l|
    if l.attr("class") == class_name + "58c"
      code = l.text.encode('iso-8859-1').force_encoding('utf-8')
    elsif l.attr("class") == class_name + "62c"
      name = l.text.delete("\n").encode('iso-8859-1').force_encoding('utf-8')
    elsif l.attr("class") == class_name + "68c"
      doc_link = l.css('a')[0]['href']
      file1 = open(doc_link)
    elsif l.attr("class") == class_name + "72c"
      level = l.text.encode('iso-8859-1').force_encoding('utf-8')
    elsif l.attr("class") == class_name + "76c"
      date = l.text
    elsif l.attr("class") == class_name + "80c"
      form = l.text.encode('iso-8859-1').force_encoding('utf-8')
    elsif l.attr("class") == class_name + "84c"
      apprent = l.text.encode('iso-8859-1').force_encoding('utf-8')
    elsif l.attr("class") == class_name + "122c"
      profile = "#{l.text.encode('iso-8859-1').force_encoding('utf-8')}(каф.#{l.next_element.text})"
    elsif l.attr("class") == class_name + "134c"
      unless l.css('a').empty?
        doc_link = l.css('a')[0]['href']
        file = open(doc_link)
        model = Document.create(university: @mephi, code: "Metod", date: Time.now, file: file, file_ext: "pdf", fullname: "Компетентностная модель", info: "Методические и иные документы, разработанные образовательной организацией для обеспечения образовательного процесса", version: @version + 1)
      end
    elsif l.attr("class") == class_name + "138c"
      description = Document.create(university: @mephi, code: "OOP", date: Time.now, file: file1, file_ext: "pdf", fullname: "Образовательный стандарт НИЯУ МИФИ", info: "Описание образовательной программы", version: @version + 1)
      prog = Program.find_or_create_by(university: @mephi, apprent: apprent, code: code, date: date, level: level, form: form, profile: profile, name: name, version: @version)
      prog.version = @version + 1
      description.program = prog
      description.save
      if model != nil
        model.program = prog
        model.save
      end
      unless l.css('a').empty?
        doc_link = l.css('a')[0]['href']
        plan = Document.create(university: @mephi, code: "Ucheb_plan", date: Time.now, file: open(doc_link), file_ext: "pdf", fullname: "Рабочий ученый план", info: "Учебный план", version: @version + 1)
        plan.program = prog
        plan.save
      end
    end
  end
end


def self.create_document(code, doc_link, doc_name, info)
  file = open(doc_link, :allow_redirections => :safe)
  file_ext = doc_link.to_s.split('.').last
  Document.create(university: @mephi, code: code, date: Time.now, file: file, file_ext: file_ext, fullname: doc_name, info: info, version: @version + 1)
  file.close
end

def self.create_document_prog(prog, code, url, fullname, info)
  begin
    file = open(url)
    file_ext = url.split('.').last
    Document.create(program: prog, university: @mephi, code: code, date: Time.now, file: file, file_ext: file_ext, fullname: fullname, info: info, version: @version + 1)
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      p "Ошибка 404 при открытии " + url
    else
      raise e
    end
  end
end

#документы
url = 'https://mephi.ru/about/govrn-state/docs.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('td.main-column').css('p')[11].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[11].css('a')[0].text
doc_link = mephi_url + link
create_document("Pologenie_structur_podrazd", doc_link, doc_name, "Cведение о наличии положения о структурных подразделениях")
link = doc.css('td.main-column').css('p')[12].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[12].css('a')[0].text
create_document("Pravila_priema", link, doc_name, "Правила приёма поступающих")
link = doc.css('td.main-column').css('p')[13].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[13].css('a')[0].text
create_document("Kol_dorovor", link, doc_name, "Коллективный договор")
link = doc.css('td.main-column').css('p')[8].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[8].css('a')[0].text
doc_link = mephi_url + link
create_document("Pravila_trud_rasporyadka", doc_link, doc_name, "Правила внутреннего трудового распорядка")
url = 'https://mephi.ru/about/charter/'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('td.main-column').css('p')[0].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[0].css('a')[0].text
doc_link = mephi_url + link
doc_link['№'] = "%E2%84%96"
create_document("Ustav", doc_link, doc_name, "Устав образовательной организации")
link = doc.css('td.main-column').css('p')[21].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[21].css('a')[0].text
doc_link = mephi_url + link
create_document("Licen", doc_link, doc_name, "Лицензия на осуществление образовательной деятельности")
link = doc.css('table')[7].css('a')[0]['href']
doc_name = doc.css('table')[7].css('a')[0].text
doc_link = mephi_url + link
create_document("Pril_Licen", doc_link, doc_name, "Приложение к лицензии на осуществление образовательной деятельности")

link = doc.css('td.main-column').css('p')[19].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[19].css('a')[0].text
doc_link = mephi_url + link
create_document("Аkkr", doc_link, doc_name, "Свидетельство о государственной аккредитации")
link = doc.css('table')[6].css('a')[0]['href']
doc_name = doc.css('table')[6].css('a')[0].text
doc_link = mephi_url + link
create_document("Pril_akkred", doc_link, doc_name, "Приложение к свидетельству о государственной аккредитации")
link = doc.css('td.main-column').css('p')[8].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[8].css('a')[0].text
doc_link = mephi_url + link
doc_link = Addressable::URI.parse(doc_link).normalize
create_document("Plan_FHD", doc_link, doc_name, "План финансово-хозяйственной деятельности образовательной организации, утверждённый в установленном законодательством Российской Федерации порядке, или бюджетные сметы образовательной организации")
url = 'https://mephi.ru/system/docs.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('td.main-column').css('p')[24].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[24].css('a')[0].text
link = Addressable::URI.parse(link).normalize
create_document("Pravila_rasporyadka", link, doc_name, "Правила внутреннего распорядка обучающихся")
link = doc.css('td.main-column').css('p')[20].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[20].css('a')[0].text
create_document("Perevod", link, doc_name, "Порядок и основания перевода, отчисления и восстановления обучающихся")
link = doc.css('td.main-column').css('p')[15].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[15].css('a')[0].text
create_document("Formi_sroki_kontrolya", link, doc_name, "Формы, периодичность и порядок текущего контроля успеваемости и промежуточной аттестации обучающихся")
url = 'https://mephi.ru/system/otchet/'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('table')[6].css('a')[0]['href']
doc_name = doc.css('table')[6].css('a')[0].text
doc_link = mephi_url + link
doc_link = Addressable::URI.parse(doc_link).normalize
create_document("Othet_o_samoobsledovanii", doc_link, doc_name, "Отчет о результатах самообследования")
url = 'https://mephi.ru/entrant/entrant2010/paidedu.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('td.main-column').css('p')[1].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[1].css('a')[0].text
create_document("Stoimost_obuch", link, doc_name, "Документ об утверждении стоимости обучения по каждой образовательной программе")
link = doc.css('td.main-column').css('p')[2].css('a')[0]['href']
doc_name = doc.css('td.main-column').css('p')[2].css('a')[0].text
doc_link = mephi_url + link
create_document("Poryadok_platn_uslug", doc_link, doc_name, "Порядок оказания платных образовательных услуг")
url = 'https://mephi.ru/entrant/2015/contracts/'
html = open(url)
doc = Nokogiri::HTML(html)
(4..13).each do |i|
  link = doc.css('td.main-column').css('li a')[i]['href']
  doc_name = doc.css('td.main-column').css('li')[i+3].text
  doc_link = mephi_url + link
  create_document("Dogovor_platn_obraz_uslug", doc_link, doc_name, "Образец договора об оказании платных образовательных услуг")
end
#департаменты
url = 'https://mephi.ru/about/departments.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('table[cellpadding="5"] tr')
d = nil
link.each do |l|
  if l.attr("style") == "background-color: rgb(150, 150, 150);" || l.attr("style") == "background-color: rgb(200, 200, 200);"
    d = Department.find_or_create_by(university: @mephi, name: l.text.strip, info: "Департамент", version: @version)
    d.version = @version + 1
    d.access_date = Time.now
    d.save
    names = l.next_element.css("b").text.strip.delete(" ").split(/(?=[А-Я])/)
    phone = l.next_element.css("td")[1].text.delete("\n").delete(" ")
    phone = nil if phone == ""
    person = Person.find_or_create_by(lastname: names[0], name: names[1], middlename: names[2], phone: phone, version: @version)
    person.version = @version + 1
    person.access_date = Time.now
    person.save
    post_name = l.next_element.css("td").text.split("\n").reject { |x| x.to_s.empty? or x.to_s == " " }
    Post.find_or_create_by(is_manage: true, name: post_name[0].strip, person: person, placeable_type: d.class.name, placeable_id: d.id)
  elsif l.attr("style") == "background-color: rgb(215, 215, 215);" && l.text.strip != ""
    e = Department.find_or_create_by(university: @mephi, name: l.text.strip, info: "Управление/отдел", head: d, version: @version)
    e.version = @version + 1
    e.access_date = Time.now
    e.save
    names = l.next_element.css("b").text.strip.delete(" ").split(/(?=[А-Я])/)
    phone = l.next_element.css("td")[1].text.delete("\n").delete(" ")
    phone = nil if phone == ""
    person = Person.find_or_create_by(lastname: names[0], name: names[1], middlename: names[2], phone: phone, version: @version)
    person.version = @version + 1
    person.access_date = Time.now
    person.save
    post_name = l.next_element.css("td").text.split("\n").reject { |e| e.to_s.empty? or e.to_s == " " }
    Post.find_or_create_by(is_manage: true, name: post_name[0].strip, person: person, placeable_type: e.class.name, placeable_id: e.id)
  end
end


#программы
create_programs('http://eis.mephi.ru/AccGateway/index.aspx?report_param_gosn=3&report_param_ismagister=false')
create_programs('http://eis.mephi.ru/AccGateway/index.aspx?report_param_gosn=3&report_param_ismagister=true')

url = 'https://mephi.ru/obrdeyat/obrazovatelnye-programmy/postgraduate-studies.php?ELEMENT_ID=99928'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('table.tbnew>tbody>tr')
asp_url = 'https://mephi.ru/obrdeyat/obrazovatelnye-programmy/'
link.each do |l|
  link2 = l.css("h4")
  code = link2.text.split.first
  name = link2.text.delete(code).strip
  link3 = l.css("table td")
  form = link3[1].text
  apprent = link3[3].text
  date = link[9].text + "года"
  prog = Program.find_or_create_by(university: @mephi, apprent: apprent, code: code, date: date, level: "Аспирант", form: form, name: name, version: @version)
  link4 = l.css("table+ul>li")
  prog.version = @version + 1
  prog.save
  url = asp_url + link4[0].children.first.attr("href")
  create_document_prog(prog, "OOP", url, link4[0].text, "Описание образовательной программы")
  url = asp_url + link4[1].children.first.attr("href")
  create_document_prog(prog, "Metod", url, link4[1].text, "Методические и иные документы, разработанные образовательной организацией для обеспечения образовательного процесса")
  url = asp_url + link4[2].children.first.attr("href")
  create_document_prog(prog, "Metod", url, "Компетентностная модель", "Методические и иные документы, разработанные образовательной организацией для обеспечения образовательного процесса")
  url = asp_url + link4[3].children.first.attr("href")
  create_document_prog(prog, "Annot", url, link4[3].text, "Аннотации к рабочим программам дисциплин")
  url = asp_url + link4[5].children.first.attr("href")
  create_document_prog(prog, "Annot", url, link4[5].text, "Аннотации к программе НИР")

  link5 = link4[4].css('a')
  link5.each do |l5|
    url = asp_url + l5['href']
    create_document_prog(prog, "Ucheb_plan", url, "Учебный план " + l5.text, "Учебный план")
  end
  link6 = link4[6].css('a')
  link6.each do |l5|
    url = asp_url + l5['href']
    create_document_prog(prog, "Ucheb_plan", url, "программа практики " + l5.text, "Аннотации к программе практики")
  end
end

#руководство
url = 'https://mephi.ru/about/leaders.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('table[style="border-collapse: collapse;"] tr')
link.each do |l|
  link2 = l.css("td")
  lastname = link2[1].text.delete("\n").strip.split(" ")[0]
  name = link2[1].text.delete("\n").strip.split(" ")[1]
  middlename = link2[1].text.delete("\n").strip.split(" ")[2]
  phone = link2[2].text.delete("\n").delete(" ").strip
  person = Person.find_or_create_by(lastname: lastname, name: name, middlename: middlename, phone: phone, version: @version)
  person.version = @version + 1
  person.save
  post_name = link2[0].text.delete("\n").strip
  Post.find_or_create_by(is_manage: true, name: post_name, person: person, placeable_type: @mephi.class.name, placeable_id: @mephi.id)
end

url = 'https://mephi.ru/about/governance.php'
html = open(url)
doc = Nokogiri::HTML(html)
link = doc.css('tr')
link.each do |l|
  break if l.text == " ОТДЕЛЫ"
  child = l.children.reject { |x| x.to_s == " " }
  if l.attr("align") == "center" || child.first.attr("bgcolor") == "#f5f5f5"
    d = Department.find_or_create_by(university: @mephi, name: l.text.strip, info: "Управление", version: @version)
    d.version = @version + 1
    d.access_date = Time.now
    d.save
    names = l.next_element.css("b").text.delete("\n").delete(" ").split(/(?=[А-Я])/)
    unless names.empty?
      phone = l.next_element.css("td")[1].text.delete(" ").split("\n").reject { |x| x.to_s.empty?}
      phone.delete_at(phone.size - 1) if phone.size > 1
      person = Person.find_or_create_by(lastname: names[0], name: names[1], middlename: names[2], phone: phone.join(" "), version: @version)
      person.version = @version + 1
      person.access_date = Time.now
      person.save
      post_name = l.next_element.css("td").text.split("\n").reject { |x| x.to_s.empty? or x.to_s == " " }
      Post.find_or_create_by(is_manage: true, name: post_name[0].strip, person: person, placeable_type: d.class.name, placeable_id: d.id)
    end
  end
end

my_object = JSON.parse(IO.read("lib/tutors.json", encoding:'utf-8'))
my_object.each do |object|
  phone = "8 (495) 788 56 99, доб. #{object["phone_number"]}" if object["phone_number"].present?
  rank = object["academic_title"] if object["academic_title"].present? && object["academic_title"]!="нет"
  degree = object["degree"] if object["degree"].present? && object["degree"]!="нет"
  middlename = object["patronymic"]
  name = object["name"]
  lastname = object["surname"]
  person = Person.find_or_create_by(phone: phone, rank: rank, degree: degree, name: name, lastname: lastname, middlename: middlename, version: @version)
  person.version = @version + 1
  person.access_date = Time.now
  person.save
  Post.find_or_create_by(is_manage: false, placeable_type: @mephi.class.name, placeable_id: @mephi.id, person: person, name: "Преподаватель")
  object["course_names"].each do |c|
    Subject.find_or_create_by(name: c, person: person, university: @mephi)
  end
end
time2 = Time.now - time1
puts "Время работы программы: " + "#{time2.round(1)}" + " секунд"
