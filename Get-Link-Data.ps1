$BaseEncUrl = 'https://www.pdrfinessetools.com/'
$BaseUrl = 'http://www.pdrfinessetools.com/'
$home_page = (Invoke-WebRequest $BaseEncUrl)
$global:first_4_of_domain = $BaseUrl.Substring(11,4)
$global:current_page = $home_page.Links.Href
$global:Links = @()


function makeLinkLists {
param ([array] $global:current_page)
  foreach ($Link in $global:current_page) {
    if ($global:Links -Contains $Link) {Continue}
    if ($Link -notlike "*$global:first_4_of_domain*") {Continue}
    echo "Added `n $Link `t TO THE LIST `n"
    $global:Links += $Link
  }
  search_recursive
}


function search_recursive {
  foreach ($Link in $global:Links) {
    $newRequest = (Invoke-WebRequest -Uri "$Link")
    $global:current_page = $newRequest.Links.Href
    makeLinkLists $global:current_page
  }
}

makeLinkLists $global:current_page
