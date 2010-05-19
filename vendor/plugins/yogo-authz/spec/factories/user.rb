def generate_name
  ["Abela","Aberahama","Aberama","Abesoloma","Abia","Abisai","Acantha",
   "Adamina","Adamu","Adara","Aditi","Adria","Aleta","Aminta","Amria",
   "Besnik", "Beti", "Blasia", "Boiko","Brishen","Calandra","Calypso",
   "Camlo","Casamir","Catarina","Cato","Chal","Chavali","Chavi","Chik",
   "Cosima","Czigany","Damara","Danior","Dooriya","Drabardi","Dudee",
   "Dukker", "Durriken", "Durril", "Electra","Esmerelda","Ferka","Fifika",
   "Flora","Florica","Garridan","Gillie","Gitana","Gypsy","Hanzi","Ilona",
   "Jal","Jibben", "Kali", "Kirvi", "Kizzy", "Lel","Lendar", "Lennor",
   "Lensar","Llesenia","Loiza","Malina", "Mander", "Manishie", "Marko",
   "Melantha", "Merripen", "Mestipen", "Mirela","Nadja","Natayla","Nicu", 
   "Olena","Oriana", "Pol","Pattin", "Pesha","Petsha", "Philana","Pias",
   "Pitivo","Pov","Pulika","Punka","Radu","Ramon","Rasia","Rawnie","Risa",
   "Rumer","Rye","Sadira","Sapphira","Shalaye","Shebari","Shey","Shofranka",
   "Shimza","Sirena","Stiggur","Syeira","Taletha","Tamas","Tas","Tawno",
   "Tem","Theron","Tobar","Tzigane","Vita","Wen","Wesh","Yanko","Yesenia",
   "Yoska","Zale","Zenda","Zenina","Zenobia","Zigana","Zindelo"][rand(123)]
end

Factory.define :user do |f|
  f.login {|x| "#{x.name.split(" ")[0]}.#{x.name.split(" ")[-1]}"}
  f.email {|x| "#{x.name.split(" ")[0]}.#{x.name.split(" ")[-1]}@someplace.com"}                  
  f.first_name generate_name
  f.last_name generate_name
  f.password 'password'
  f.password_confirmation 'password'
end
