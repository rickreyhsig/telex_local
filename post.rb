require 'rubygems'
require 'watir'
cnf = YAML::load_file(File.join('/Users/ricardokreyhsig/Desktop/TelexAutoPost', 'config.yml'))
user = cnf['user']

# Authenticate
browser = Watir::Browser.new 
browser.goto 'https://office.telexbit.com/'
browser.text_field(name: 'username').set cnf['user']
browser.text_field(name: 'password').set cnf['password']
browser.execute_script("alert(\"Please resolve the CAPTCHA to continue.\")") 
sleep 3
#browser.alert.ok

# Make sure auth worked
browser.link(:text =>'3 - Valide seus anúncios').wait_until_present

# Grab anuncio text
browser.goto 'http://brasiltelexbit.com/publicar.php'
browser.text_field(name: 'usernames[]').set user
browser.input(:type =>'submit').click
anuncio_text = browser.link(:id => 'ad'+user+'0').text

# Post ads
browser.goto 'https://office.telexbit.com/'
browser.link(:text =>'3 - Valide seus anúncios').click
[0,1,2,3,4].each do |num|
	#browser.select_list(:name, "n_adcentral").wait_until_present
	browser.select_list(:name, "n_adcentral").select_value(num.to_s)
	browser.text_field(id: 'site_ads').set anuncio_text
	browser.text_field(id: 'link_ads').set anuncio_text+num.to_s
	browser.button(type: 'submit').click
	sleep 1
	p "#{num} --- \xE2\x9C\x94 "
	browser.goto 'https://office.telexbit.com/Ads/AdsSelectIII'
end

p 'Done posting ads'
browser.goto 'https://office.telexbit.com/Ads/MyAdcentral'
puts browser.title
browser.close