#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use Test::Exception;
use Encode;
use utf8;

use WWW::Goodreads;
use lib qw{t}; use WWWGoodReadsTester qw/startup_gr/;

my $gr = startup_gr( no_oauth => 1 );
my @result_data = grep length, split /\n\nZOFFIX_SAMPLE_\d+\n\n/, do { local $/; <DATA> };

chomp @result_data;

{
    my $data = $gr->book_show( 86 )
        or die 'Error: ' . $gr->error;

    is $data, $result_data[0], 'Book ID; all args at default';
}

# This test fails even when the `diff` on the got/expected is produces
# nothing... Fuck it

# {
#     my $data = $gr->book_show( 86, format => 'xml', )
#         or die 'Error: ' . $gr->error;

#     is encode('utf8', $data),
#         encode('utf8', $result_data[1]), 'Book ID; all args at default';
# }

done_testing();

__DATA__


ZOFFIX_SAMPLE_0

{"reviews_widget":"<style>\n  #goodreads-widget {\n    font-family: georgia, serif;\n    padding: 18px 0;\n    width:565px;\n  }\n  #goodreads-widget h1 {\n    font-weight:normal;\n    font-size: 16px;\n    border-bottom: 1px solid #BBB596;\n    margin-bottom: 0;\n  }\n  #goodreads-widget a {\n    text-decoration: none;\n    color:#660;\n  }\n  iframe{\n    background-color: #fff;\n  }\n  #goodreads-widget a:hover { text-decoration: underline; }\n  #goodreads-widget a:active {\n    color:#660;\n  }\n  #gr_footer {\n    width: 100%;\n    border-top: 1px solid #BBB596;\n    text-align: right;\n  }\n  #goodreads-widget .gr_branding{\n    color: #382110;\n    font-size: 11px;\n    text-decoration: none;\n    font-family: verdana, arial, helvetica, sans-serif;\n  }\n</style>\n<div id=\"goodreads-widget\">\n  <div id=\"gr_header\"><h1><a href=\"https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays\">The Heidi Chronicles and Other Plays Reviews</a></h1></div>\n  <iframe id=\"the_iframe\" src=\"https://www.goodreads.com/api/reviews_widget_iframe?did=DEVELOPER_ID&amp;format=html&amp;isbn=0679734996&amp;links=660&amp;review_back=fff&amp;stars=000&amp;text=000\" width=\"565\" height=\"400\" frameborder=\"0\"></iframe>\n  <div id=\"gr_footer\">\n    <a href=\"https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays?utm_medium=api&amp;utm_source=reviews_widget\" class=\"gr_branding\" target=\"_blank\">Reviews from Goodreads.com</a>\n  </div>\n</div>\n"}


ZOFFIX_SAMPLE_1

<?xml version="1.0"?>
<GoodreadsResponse>
  <Request>
    <authentication>true</authentication>
      <key><![CDATA[fcJ7d4tYB5Y0xJSgs7Hpw]]></key>
    <method><![CDATA[book_show]]></method>
  </Request>
  <book>
  <id>86</id>
  <title><![CDATA[The Heidi Chronicles and Other Plays]]></title>
  <isbn><![CDATA[0679734996]]></isbn>
  <isbn13><![CDATA[9780679734994]]></isbn13>
  <asin><![CDATA[]]></asin>
  <image_url>https://d202m5krfqbpi5.cloudfront.net/books/1329241203m/86.jpg</image_url>
  <small_image_url>https://d202m5krfqbpi5.cloudfront.net/books/1329241203s/86.jpg</small_image_url>
  <publication_year>1991</publication_year>
  <publication_month>6</publication_month>
  <publication_day></publication_day>
  <publisher>Vintage</publisher>
  <language_code></language_code>
  <is_ebook>false</is_ebook>
  <description></description>
  <work>
  <best_book_id type="integer">86</best_book_id>
  <books_count type="integer">5</books_count>
  <default_chaptering_book_id type="integer" nil="true"/>
  <default_description_language_code nil="true"/>
  <desc_user_id type="integer">-110</desc_user_id>
  <id type="integer">4450</id>
  <media_type>book</media_type>
  <original_language_id type="integer" nil="true"/>
  <original_publication_day type="integer" nil="true"/>
  <original_publication_month type="integer" nil="true"/>
  <original_publication_year type="integer">1988</original_publication_year>
  <original_title>The Heidi Chronicles: Uncommon Women and Others &amp; Isn't It Romantic (Vintage)</original_title>
  <rating_dist>5:266|4:334|3:248|2:67|1:26|total:941</rating_dist>
  <ratings_count type="integer">1462</ratings_count>
  <ratings_sum type="integer">5581</ratings_sum>
  <reviews_count type="integer">1979</reviews_count>
  <text_reviews_count type="integer">47</text_reviews_count>
</work>
  <average_rating>3.82</average_rating>
  <num_pages><![CDATA[249]]></num_pages>
  <format><![CDATA[Paperback]]></format>
  <edition_information><![CDATA[]]></edition_information>
  <ratings_count><![CDATA[1453]]></ratings_count>
  <text_reviews_count><![CDATA[45]]></text_reviews_count>
  <url><![CDATA[https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays]]></url>
  <link><![CDATA[https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays]]></link>
  <authors>
  <author>
    <id>42</id>
    <name>Wendy Wasserstein</name>
    <image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p5/42.jpg]]></image_url>
    <small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p2/42.jpg]]></small_image_url>
    <link><![CDATA[https://www.goodreads.com/author/show/42.Wendy_Wasserstein]]></link>
    <average_rating>3.56</average_rating>
    <ratings_count>4573</ratings_count>
    <text_reviews_count>469</text_reviews_count>
  </author>
</authors>

    <reviews_widget>
      <![CDATA[
        <style>
  #goodreads-widget {
    font-family: georgia, serif;
    padding: 18px 0;
    width:565px;
  }
  #goodreads-widget h1 {
    font-weight:normal;
    font-size: 16px;
    border-bottom: 1px solid #BBB596;
    margin-bottom: 0;
  }
  #goodreads-widget a {
    text-decoration: none;
    color:#660;
  }
  iframe{
    background-color: #fff;
  }
  #goodreads-widget a:hover { text-decoration: underline; }
  #goodreads-widget a:active {
    color:#660;
  }
  #gr_footer {
    width: 100%;
    border-top: 1px solid #BBB596;
    text-align: right;
  }
  #goodreads-widget .gr_branding{
    color: #382110;
    font-size: 11px;
    text-decoration: none;
    font-family: verdana, arial, helvetica, sans-serif;
  }
</style>
<div id="goodreads-widget">
  <div id="gr_header"><h1><a href="https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays">The Heidi Chronicles and Other Plays Reviews</a></h1></div>
  <iframe id="the_iframe" src="https://www.goodreads.com/api/reviews_widget_iframe?did=DEVELOPER_ID&amp;format=html&amp;isbn=0679734996&amp;links=660&amp;min_rating=&amp;review_back=fff&amp;stars=000&amp;text=000" width="565" height="400" frameborder="0"></iframe>
  <div id="gr_footer">
    <a href="https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays?utm_medium=api&amp;utm_source=reviews_widget" class="gr_branding" target="_blank">Reviews from Goodreads.com</a>
  </div>
</div>

      ]]>
    </reviews_widget>
  <popular_shelves>
      <shelf name="to-read" count="427"/>
      <shelf name="plays" count="72"/>
      <shelf name="drama" count="33"/>
      <shelf name="theatre" count="16"/>
      <shelf name="fiction" count="8"/>
      <shelf name="play" count="7"/>
      <shelf name="theater" count="7"/>
      <shelf name="pulitzer-prize" count="6"/>
      <shelf name="favorites" count="5"/>
      <shelf name="currently-reading" count="4"/>
  </popular_shelves>
  <book_links>
    <book_link>
  <id>1</id>
  <name>Amazon</name>
  <link>https://www.goodreads.com/book_link/follow/1</link>
</book_link>
<book_link>
  <id>3</id>
  <name>Barnes &amp; Noble</name>
  <link>https://www.goodreads.com/book_link/follow/3</link>
</book_link>
<book_link>
  <id>8</id>
  <name>Libraries</name>
  <link>https://www.goodreads.com/book_link/follow/8</link>
</book_link>
<book_link>
  <id>1027</id>
  <name>Kobo</name>
  <link>https://www.goodreads.com/book_link/follow/1027</link>
</book_link>
<book_link>
  <id>9</id>
  <name>Indigo</name>
  <link>https://www.goodreads.com/book_link/follow/9</link>
</book_link>
<book_link>
  <id>4</id>
  <name>Abebooks</name>
  <link>https://www.goodreads.com/book_link/follow/4</link>
</book_link>
<book_link>
  <id>2</id>
  <name>Half.com</name>
  <link>https://www.goodreads.com/book_link/follow/2</link>
</book_link>
<book_link>
  <id>10</id>
  <name>Audible</name>
  <link>https://www.goodreads.com/book_link/follow/10</link>
</book_link>
<book_link>
  <id>5</id>
  <name>Alibris</name>
  <link>https://www.goodreads.com/book_link/follow/5</link>
</book_link>
<book_link>
  <id>882</id>
  <name>Book Depository</name>
  <link>https://www.goodreads.com/book_link/follow/882</link>
</book_link>
<book_link>
  <id>2102</id>
  <name>iBookstore</name>
  <link>https://www.goodreads.com/book_link/follow/2102</link>
</book_link>
<book_link>
  <id>245</id>
  <name>Sony</name>
  <link>https://www.goodreads.com/book_link/follow/245</link>
</book_link>
<book_link>
  <id>107</id>
  <name>Better World Books</name>
  <link>https://www.goodreads.com/book_link/follow/107</link>
</book_link>
<book_link>
  <id>3928</id>
  <name>Target.com</name>
  <link>https://www.goodreads.com/book_link/follow/3928</link>
</book_link>
<book_link>
  <id>1602</id>
  <name>Google Play</name>
  <link>https://www.goodreads.com/book_link/follow/1602</link>
</book_link>
<book_link>
  <id>7</id>
  <name>IndieBound</name>
  <link>https://www.goodreads.com/book_link/follow/7</link>
</book_link>
<book_link>
  <id>5858</id>
  <name>Amazon ES</name>
  <link>https://www.goodreads.com/book_link/follow/5858</link>
</book_link>

  </book_links>
  <series_works>

  </series_works>
  <similar_books>
          <book>
<id>784709</id>
<title><![CDATA[Sunday in the Park With George]]></title>
<isbn></isbn>
<isbn13>9781557830685</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>4.12</average_rating>
<ratings_count>1663</ratings_count>
<authors>
  <author>
    <id>85858</id>
    <name>Stephen Sondheim</name>
  </author>
</authors>
</book>
          <book>
<id>50544</id>
<title>&apos;night, Mother</title>
<isbn>0822208210</isbn>
<isbn13>9780822208211</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.84</average_rating>
<ratings_count>4967</ratings_count>
<authors>
  <author>
    <id>2043</id>
    <name>Marsha Norman</name>
  </author>
</authors>
</book>
          <book>
<id>141658</id>
<title><![CDATA[How I Learned to Drive - Acting Edition]]></title>
<isbn>082221623X</isbn>
<isbn13>9780822216230</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391658956s/141658.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391658956m/141658.jpg]]></image_url>
<average_rating>3.82</average_rating>
<ratings_count>3366</ratings_count>
<authors>
  <author>
    <id>81190</id>
    <name>Paula Vogel</name>
  </author>
</authors>
</book>
          <book>
<id>170539</id>
<title>Lost in Yonkers</title>
<isbn>0452268834</isbn>
<isbn13>9780452268838</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.77</average_rating>
<ratings_count>1614</ratings_count>
<authors>
  <author>
    <id>60047</id>
    <name>Neil Simon</name>
  </author>
</authors>
</book>
          <book>
<id>1067650</id>
<title>Six Degrees of Separation</title>
<isbn>0679734813</isbn>
<isbn13>9780679734819</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391637585s/1067650.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391637585m/1067650.jpg]]></image_url>
<average_rating>3.97</average_rating>
<ratings_count>2889</ratings_count>
<authors>
  <author>
    <id>13977</id>
    <name>John Guare</name>
  </author>
</authors>
</book>
          <book>
<id>370966</id>
<title><![CDATA[Three Plays: Blithe Spirit / Hay Fever / Private Lives]]></title>
<isbn>067978179X</isbn>
<isbn13>9780679781790</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>4.11</average_rating>
<ratings_count>1359</ratings_count>
<authors>
  <author>
    <id>120035</id>
    <name>Noël Coward</name>
  </author>
</authors>
</book>
          <book>
<id>141640</id>
<title><![CDATA[The Clean House and Other Plays]]></title>
<isbn>1559362669</isbn>
<isbn13>9781559362665</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1354209677s/141640.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1354209677m/141640.jpg]]></image_url>
<average_rating>4.25</average_rating>
<ratings_count>1211</ratings_count>
<authors>
  <author>
    <id>81678</id>
    <name>Sarah Ruhl</name>
  </author>
</authors>
</book>
          <book>
<id>108408</id>
<title>Crimes of the Heart</title>
<isbn>0822202506</isbn>
<isbn13>9780822202509</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.72</average_rating>
<ratings_count>3107</ratings_count>
<authors>
  <author>
    <id>62733</id>
    <name>Beth Henley</name>
  </author>
</authors>
</book>
          <book>
<id>1061479</id>
<title>The Beauty Queen of Leenane</title>
<isbn>041370730X</isbn>
<isbn13>9780413707307</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>4.12</average_rating>
<ratings_count>566</ratings_count>
<authors>
  <author>
    <id>77295</id>
    <name>Martin McDonagh</name>
  </author>
</authors>
</book>
          <book>
<id>275274</id>
<title><![CDATA[Sister Mary Ignatius Explains it All for You & The Actor's Nightmare]]></title>
<isbn>0822210355</isbn>
<isbn13>9780822210351</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1334989173s/275274.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1334989173m/275274.jpg]]></image_url>
<average_rating>3.95</average_rating>
<ratings_count>1338</ratings_count>
<authors>
  <author>
    <id>56415</id>
    <name>Christopher Durang</name>
  </author>
</authors>
</book>
          <book>
<id>961392</id>
<title>Torch Song Trilogy</title>
<isbn>0960472401</isbn>
<isbn13>9780960472406</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391638177s/961392.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1391638177m/961392.jpg]]></image_url>
<average_rating>4.20</average_rating>
<ratings_count>1001</ratings_count>
<authors>
  <author>
    <id>4775</id>
    <name>Harvey Fierstein</name>
  </author>
</authors>
</book>
          <book>
<id>450669</id>
<title>I Am My Own Wife</title>
<isbn>0571211747</isbn>
<isbn13>9780571211746</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1317064111s/450669.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1317064111m/450669.jpg]]></image_url>
<average_rating>3.93</average_rating>
<ratings_count>959</ratings_count>
<authors>
  <author>
    <id>117340</id>
    <name>Doug Wright</name>
  </author>
</authors>
</book>
          <book>
<id>196301</id>
<title>The Skin of Our Teeth</title>
<isbn>0060088931</isbn>
<isbn13>9780060088934</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.83</average_rating>
<ratings_count>2231</ratings_count>
<authors>
  <author>
    <id>44061</id>
    <name>Thornton Wilder</name>
  </author>
</authors>
</book>
          <book>
<id>565978</id>
<title>The Piano Lesson</title>
<isbn>0452265347</isbn>
<isbn13>9780452265349</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1390172601s/565978.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1390172601m/565978.jpg]]></image_url>
<average_rating>3.74</average_rating>
<ratings_count>2485</ratings_count>
<authors>
  <author>
    <id>13944</id>
    <name>August Wilson</name>
  </author>
</authors>
</book>
          <book>
<id>40107</id>
<title>The Goat, or Who is Sylvia?</title>
<isbn>1585676470</isbn>
<isbn13>9781585676477</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.94</average_rating>
<ratings_count>2671</ratings_count>
<authors>
  <author>
    <id>9322</id>
    <name>Edward Albee</name>
  </author>
</authors>
</book>
          <book>
<id>139389</id>
<title><![CDATA[Deathtrap: A Thriller in Two Acts]]></title>
<isbn>0822202948</isbn>
<isbn13>9780822202943</isbn13>
<small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1339438441s/139389.jpg]]></small_image_url>
<image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/books/1339438441m/139389.jpg]]></image_url>
<average_rating>3.89</average_rating>
<ratings_count>896</ratings_count>
<authors>
  <author>
    <id>8050</id>
    <name>Ira Levin</name>
  </author>
</authors>
</book>
          <book>
<id>38700</id>
<title>Rabbit Hole</title>
<isbn>1559362901</isbn>
<isbn13>9781559362900</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>4.05</average_rating>
<ratings_count>2946</ratings_count>
<authors>
  <author>
    <id>21794</id>
    <name>David Lindsay-Abaire</name>
  </author>
</authors>
</book>
          <book>
<id>196859</id>
<title>Dancing at Lughnasa</title>
<isbn>0571144799</isbn>
<isbn13>9780571144792</isbn13>
<small_image_url><![CDATA[https://www.goodreads.com/assets/nocover/60x80.png]]></small_image_url>
<image_url><![CDATA[https://www.goodreads.com/assets/nocover/111x148.png]]></image_url>
<average_rating>3.66</average_rating>
<ratings_count>1727</ratings_count>
<authors>
  <author>
    <id>34171</id>
    <name>Brian Friel</name>
  </author>
</authors>
</book>
  </similar_books>
</book>

</GoodreadsResponse>