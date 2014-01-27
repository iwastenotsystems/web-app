'use strict';

# jasmine specs for filters go here

describe 'myApp.filters', ->

  beforeEach module('myApp')

  describe 'markdown converter', ->
    it 'should insert <em> tags around text surrounded by single asterisks',
      inject ($sce, markdownFilter) ->
        expect($sce.getTrustedHtml(markdownFilter '*Markdown*'))
        .toEqual "<p><em>Markdown</em></p>\n"

    it 'should insert <strong> tags around text surrounded by double asterisks',
      inject ($sce, markdownFilter) ->
        expect($sce.getTrustedHtml(markdownFilter '**Markdown**'))
        .toEqual "<p><strong>Markdown</strong></p>\n"

  describe 'markdown sanitizer', ->
    it 'should strip unbalanced tags from the output',
      inject ($sce, markdownFilter) ->
        expect($sce.getTrustedHtml(markdownFilter '<b>Unmatched tag'))
        .toEqual "<p>&lt;b&gt;Unmatched tag</p>\n"

    it 'should remove script tags from the output',
      inject ($sce, markdownFilter) ->
        expect(
          $sce.getTrustedHtml(markdownFilter '<script>alert("Bug");</script>'))
        .toEqual """<p>&lt;script&gt;alert(“Bug”);&lt;/script&gt;</p>\n"""

  describe 'markdown extra', ->
    it 'should render tables', inject ($sce, markdownFilter) ->
      input = """
        | Left | Center | Right |
        | :--- | :----: | ----: |
        | 1    |    2   |     3 |

        """
      output = """<table>
        <thead>
        <tr>
        <th style="text-align:left">Left</th>
        <th style="text-align:center">Center</th>
        <th style="text-align:right">Right</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:center">2</td>
        <td style="text-align:right">3</td>
        </tr>
        </tbody>
        </table>

        """
      expect($sce.getTrustedHtml(markdownFilter input)).toEqual output

