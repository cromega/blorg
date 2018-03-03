{
  "title":"{{ page.title | escape }}",
  "body":"{{ page.content | markdownify | newline_to_br | strip_newlines | escape }}",
  "date":"{{ page.date | escape }}",
  "tags":"{{ page.tags | jsonify | escape }}"
}

