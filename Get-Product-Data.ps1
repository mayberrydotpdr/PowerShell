$BaseEncUrl = 'https://www.pdrfinessetools.com/'
$BaseUrl = 'http://www.pdrfinessetools.com/'
$home_page = (Invoke-WebRequest $BaseEncUrl)
$global:first_4_of_domain = $BaseUrl.Substring(11,4)
$global:current_page = $home_page.Links.href
$global:allLinks = @()
$global:Links = @()
$global:ProductData = @()


function makeLinkLists {
param ([array] $current_page)
  foreach ($Link in $current_page) {
    if ($Links -Contains $Link) {Continue}
    if ($Link -notlike "*$global:first_4_of_domain*") {Continue}
    $global:Links += $Link
    if ($global:allLinks -Contains $Link) {Continue}
    $global:allLinks += $Link
  }
  AddProductData
}


function getProductData {
  param ([string] $product_url)
    $h1 = (Invoke-WebRequest -URI $product_url)
    $start_h1_text = $h1.Content.IndexOf('<h1>') + 4
    $endOF_h1_text = $h1.Content.IndexOf('</h1>' )
    $h1_length = $endOF_h1_text - $start_h1_text
    if ($h1_length -gt 0){
      $Product = $h1.Content.Substring($start_h1_text, $h1_length)
      if ($Product -notlike '*<*'){
        $h1.Content.Substring($start_h1_text, $h1_length)
      }
    }
}

function AddProductData {
foreach ($Link in $global:Links) {
echo 'i ran'
echo $Link
$i = getProductData $Link
if ($global:ProductData -Contains $i) {Continue}
$global:ProductData += $i
}
search_recursive
}

function search_recursive {
  foreach ($Link in $global:Links) {
    $global:current_page = $Link
    makeLinkLists $current_page
  }
  $global:Links = @()
}

makeLinkLists $current_page
