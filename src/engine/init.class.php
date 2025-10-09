<?php

/**
 * Общий «инициализатор»: загрузка конфигурации, проверка авторизации,
 * подготовка данных для шаблонов.
 */

declare(strict_types=1);

$addheadtags = '';
$post2pdflink = '/pdfversion.php?url=' . urlencode($thispagesimpleurl)
  . '&hash=' . md5('p-d-f-' . $thispagesimpleurl);

$legal_entity_project_data = $config['project_tax_id'] . '<br>' . $config['project_legal_address'];
if ($country_code == 'US') {
    $legal_entity_project_data = ''; // временно
}

if ($user_lng == 'ru') {
    $config['project_name'] = 'МОСТ.Медиа';
} elseif ($user_lng == 'en') {
    $config['project_name'] = 'MOST News';
} else {
    $config['project_name'] = 'MOST.' . getphrase('Media');
}

$profilemenuitem = str_replace('dropdown header__user', 'dropup header__user', $profilemenuitem);
$profilemenuitem = str_replace(' style="background-color:transparent;"', '', $profilemenuitem);
$profilemenuitem = str_replace('<ul class="dropdown-menu">', '<ul class="dropdown-menu" style="">', $profilemenuitem);
$profilemenuitem = str_replace(
    '</div></a>',
    '</div> <span class="link-footer">' . $username . '</span></a>',
    $profilemenuitem
);

$search = '<span class="glyphicon glyphicon-log-in" aria-hidden="true" '
  . 'style="padding: 10px 5px;background-color:transparent;font-size:17px;margin-top:-4px;"></span> ';
$profilemenuitem = str_replace($search, '', $profilemenuitem);

$profilemenuitem = str_replace(
    '<a href="javascript:void(0)" onclick="loginform()">',
    '<a href="javascript:void(0)" onclick="loginform()" style="display:none;">',
    $profilemenuitem
);
$profilemenuitem = str_replace(
    '<li class="header__login">',
    '<li class="header__login" style="display:none;">',
    $profilemenuitem
);

if ($user_lng == 'ru') {
    $projecttext1 = 'Поддержите автора посильным пожертвованием. Разовым, а&nbsp;еще лучше — ежемесячным. '
    . 'Это позволит нам пережить трудности первых месяцев работы и&nbsp;построить крепкий «Мост».';
} else {
    $projecttext1 = getphrase(
        'If you enjoyed this article, consider making a donation — one-time or, even better, monthly. '
        . 'Your support helps us motivate our authors and become better with every article.'
    );
}

$supportustext = getphrase('Enjoyed the article?') . '<br>' . getphrase('Support the author!');
$supportus = get_template('supportus');

if (empty($userdata['email'])) {
    $userdata['email'] = '';
}

if ($user_lng == 'ru') {
    $sharephrase = 'ПОДЕЛИТЬСЯ';
} else {
    $sharephrase = 'SHARE';
}

$categorybanner = '';
if ($blog_id == 13770 && $thispath[2] == 'culture') {
    $categorybanner = get_template('categorybanner');
    $blogsearchhtml = '';
}

/**
 * -----------------------------------------------------------------------------
 * Поиск
 * -----------------------------------------------------------------------------
 */

$searchDefaults = [
  'label'          => getphrase('Search'),
  'title'          => getphrase('Search the site'),
  'input_label'    => getphrase('What are we looking for?'),
  'placeholder'    => getphrase('Find…'),
  'submit_label'   => getphrase('Search'),
  'param'          => 'q',
  'results_page'   => '/' . substr((string) $lng_html, 0, 2) . '/search',
  'examples_title' => getphrase('Popular queries'),
  'examples'       => [],
];

$searchConfig = [];
$siteJson = __DIR__ . '/../templates/data/site.json';

if (is_file($siteJson)) {
    $json = json_decode(file_get_contents($siteJson), true);
    if (is_array($json) && !empty($json['search'])) {
        $searchConfig = $json['search'];
    }
}

$search = array_merge($searchDefaults, array_intersect_key($searchConfig, $searchDefaults));

$search['action'] = !empty($searchConfig['action'])
  ? (string) $searchConfig['action']
  : $search['results_page'];

$search['examples'] = [];
if (!empty($searchConfig['examples']) && is_array($searchConfig['examples'])) {
    foreach ($searchConfig['examples'] as $item) {
        if (!empty($item['href'])) {
            $search['examples'][] = [
            'q'    => isset($item['q']) ? (string) $item['q'] : '',
            'href' => (string) $item['href'],
            ];
        }
    }
}

if (count($search['examples']) < 4) {
    $search['examples'] = array_pad(
        $search['examples'],
        4,
        ['q' => '', 'href' => $search['action']]
    );
}
