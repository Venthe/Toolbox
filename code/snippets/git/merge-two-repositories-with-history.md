# Merging 2 Different Git Repositories Without Losing your History

Today, I had to merge a git based project into another one. Nothing seems simpler, I just had to remove the .git directory, pick up the files, git commit -a -S -m “Merging old project into the new one” and we’re done.

Except that I didn’t want to lose the first project history in the process. Keeping the full log is useful to understand why things were done in a way, or why they were done at all.

Thankfully, git is powerful enough to allow merging 2 repositories into one without losing the history.

First thing to do is to clone both projects.

```bash
git clone [git@server.com](mailto:git@server.com):old-project.git  
git clone [git@server.com](mailto:git@server.com):new-project.git
```

If you want the old project to be a subdirectory of the new project, add this:

```bash
cd old-project  
mkdir old-project  
git mv !(old-project) old-project  
git commit -a -S -m “Moving old project into its own subdirectory”
```

`!(old-project)` is a bashism that says “everything but old-project”. If your project is called the girl, then you move “everything but the girl”.

Sorry, not sorry.

Now comes the merging part. What we’re doing is add a remote to the old project, and merge everything into the new one. Since git doesn’t allow merges without a common history, we’ll have to force it using the allow-unrelated-histories option. And since we love well maintained projects, we’re doing everything in a branch we’ll merge after a code review is done.

```bash
cd ../new-project  
git remote add old-project ../old-project  
git fetch old-project  
git checkout -b feature/merge-old-project  
git merge -S --allow-unrelated-histories old-project/master  
git push origin feature/merge-old-project  
git remote rm old-project
```

Tada! You’re done. If you run git log, you’ll see the commits of both projects mixed into your log. That’s the magic.

Question. Why didn’t I rebase?

Well, because git documentation says you shouldn’t. [Quoting The Perils of Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing#_rebase_peril),

> Do not rebase commits that exist outside your repository.
> 
> If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.
> 
> When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with git rebase and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

That’s all folks, see you soon!
