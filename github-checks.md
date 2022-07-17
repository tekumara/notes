# github checks

<!-- markdownlint-disable MD033 -->
<img src="images/github-checks-sequence-diagram.svg" alt="GitHub Checks sequence diagram" width="500"/>
<!-- markdownlint-enable MD033 -->

Check suite requested is generated per commit, not per pr. This means if you create a new pr for the exact same commit, the check suite will be the same.
