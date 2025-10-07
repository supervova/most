<?php

$files = [
    "index.html"     => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/index.html?PageSpeed=off"),
    "conflicts.html" => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/conflicts.html?PageSpeed=off"),
    "culture.html"   => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/culture.html?PageSpeed=off"),
    "economy.html"   => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/economy.html?PageSpeed=off"),
    "opinions.html"  => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/opinions.html?PageSpeed=off"),
    "politics.html"  => "https://anonymno.com/c.php?u=".urlencode("https://mostmedia.org/ru/politics.html?PageSpeed=off")
];

$lines = ["TsvHttpData-1.0"];

foreach ($files as $destName => $url) {
    $context = stream_context_create([
        'http' => [
            'header' => "User-Agent: Cron\r\n"
        ]
    ]);

    $content = @file_get_contents($url, false, $context);

    if ($content === false) {
		sleep(1);
	    $content = @file_get_contents($url, false, $context);
		if ($content === false) {
			die("Error");
		}
    }

    $length = strlen($content);
    $md5Base64 = base64_encode(md5($content, true));

    $lines[] = "$url\t$length\t$md5Base64\t$destName";
}

$tsv = implode("\n", $lines);
header('Content-Type: text/plain; charset=utf-8');
header('Content-Disposition: inline; filename="url-list.tsv"');
echo $tsv;
die();
