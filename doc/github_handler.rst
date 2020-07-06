GitHub Handler
==============

GitHub Handler is a Universum mode that serves as GitHub Application, helping to perform and report checks on
new commits to a repository. In this mode Universum can create new check runs on GitHub and trigger an already
set up automation server to perform these checks. GitHub Handler parses all required params and passes them
to the triggered builds.


How to set up GitHub auto check using Unversum
----------------------------------------------

Universum in default, 'main' mode when set up to ``--vcs-type=github`` and with ``--report-to-review`` passed
as parameter, can post `check run` statuses to GitHub to be depicted on 'Checks' page in pull requests or as
a simple icon near any checked commit. To do so, it needs `a set of parameters <args.html#GitHub>`__
to be passed to it.

.. note::

    During these checks, if some steps were using :doc:`Universum analyzers <code_report>`,
    and any issues are found, they will also be reported in comments.

These required parameters are sent by GitHub via web-hooks after the reuired `check run` is created. To do so,
a GitHub Application is required, and GitHub Handler could be used as such.

.. note::

    GitHub Handler is a simple script, receiving web-hook payload and event as parameters.
    To work as GitHub Application it still needs a server to receive actual web-hooks and pass their
    contents as parameters to Handler.

One of the easiest ways to make it work is to put the GitHub Handler execution into an automation server
(such as Jenkins) job triggered by incoming web-hooks from GitHub. GitHub Handler parses the incoming
web-hook event (passed via "x-github-event" header) and payload content. If a new `check run` is required,
it sends a request to GitHub to create one. If the `check run` is already created, it parses the required parameters
and triggers the set up automation server to run a previously described check by usual Universum.

The following picture represents the event sequence leading to check result for a commit displayed on GitHub:

*(picture here)*

On this picture numbers depict the following events:

1. User makes a new commit
2. GitHub detects a commit, creates a check suite and sends a web-hook payload to GitHub Handler
3. GitHub Handler checks that repo name and web-hook event are applicable and and sends a request
   to create a new check run to GitHub
4. GitHub creates a new check run and sends a new web-hook payload about this event
5. GitHub Handler triggers a usual `Universum` run on an already set up automation server,
   retrieving all required parameters from GitHub web-hook payload and passing them to the build
6. Universum in default mode with ``--report-to-review`` on and ``--vcs-type=github`` uses received parameters
   to report build ('check') start
7. Depending on build result, Universum either reports build success or failure

After this, check result can be viewed directly on GitHub.

.. note::

    GitHub also sends web-hook payloads on other events (such as *'check run completed'*), that are
    currently ignored by GitHub Handler
