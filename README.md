#Staticly

[![Build Status](https://travis-ci.org/bringel/staticly.png?branch=master)](https://travis-ci.org/bringel/staticly)

[Trello Board](https://trello.com/b/jLj8SwnF)

Staticly is an iOS application that allows you to edit your jekyll generated sites and blogs on the go.

Here are the things that are planned for the first version:

Allow users to connect to github and pick a repository and branch for Jekyll

"Clone" repository locally into Core Data store using AFNetworking

Create New Posts in either `_posts` or `_drafts`

Edit Posts with an extra Markdown formatting toolbar.

Saving creates commits

Markdown can be previewed, but only the content, not using anything from `_layouts`

Posts can be moved from `_drafts` to `_posts`

v1 will only handle connecting to github and can only handle jekyll sites that can be generated by github (no plugins).
Letting github do the work for us takes away a lot of development time that would need to be spent reimplementing much of jekyll


If there are features that you think should be in v1 or in future verisons, open an issue.
