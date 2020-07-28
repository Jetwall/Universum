GitHub Handler
==============

GitHub Handler is a Universum mode that serves as GitHub Application, helping to perform and report checks on
new commits to a repository. It can create new check runs on GitHub and trigger an already set up automation server
to perform these checks. GitHub Handler parses all required params and passes them to the triggered builds.


How to set up GitHub auto check using Unversum
----------------------------------------------

Default Universum ('main' mode) can post `check run` statuses to GitHub to be depicted both on 'Checks' page
in pull requests and as a simple icon near any checked commit.
To do so, it needs a set of parameters to be passed to it:

* ``--vcs-type=github``
* ``--report-to-review``
* `GitHub-related parameters <args.html#GitHub>`__

.. note::

    During these checks, if some steps were using :doc:`Universum analyzers <code_report>`,
    and any issues are found, they will also be reported in comments. See
    `this example <https://github.com/Samsung/Universum/pull/459/commits/f777fad41fd7de37365f17dc20e3e34b2ffdeee7>`_.

Some of these required parameters are sent by GitHub via web-hooks after the required `check run` is created:

* ``--git-repo``: exact repository to pull sources from
* ``--git-refspec``: PR source branch to perform check on
* ``--git-checkout-id``: exact commit ID from the branch (not necessarily latest) to check
* ``--github-check-id``: GitHub check run ID to be reported to
* ``--github-installation-id``: parameter required for authorization

To get a web-hook payload and retrieve the last two of these parameters, a GitHub Application is required,
and GitHub Handler could be used as such.

.. note::

    GitHub Handler is a simple script, receiving web-hook payload and event as parameters.
    To work as GitHub Application it still needs a web server to receive actual web-hooks and pass their
    contents as parameters to Handler.

One of the easiest ways to make it work is to put the GitHub Handler execution into an automation server
(such as Jenkins) job triggered by incoming web-hooks from GitHub. GitHub Handler parses the incoming
web-hook event (passed via "x-github-event" header) and payload content. If a new `check run` is required,
it sends a request to GitHub to create one. If the `check run` is already created, it parses the required parameters
and triggers the set up automation server to run a previously described check by Universum in 'main' mode (see above).

The following picture represents the event sequence leading to check result for a commit displayed on GitHub:

*(picture here)*

On this picture numbers depict the following events:

1. User makes a new commit
2. GitHub detects a commit, creates a check suite and sends a web-hook payload to Jenkins server
3. A preconfigured Jenkins job passes received parameters to GitHub Handler
4. GitHub Handler checks that repo name and web-hook event are applicable and and sends a request
   to create a new check run to GitHub
5. GitHub creates a new check run and sends a new web-hook payload about this event
6. GitHub Handler triggers a usual `Universum` run on an already set up automation server,
   retrieving all required parameters from GitHub web-hook payload and passing them to the build
7. Universum in default mode with ``--report-to-review`` on and ``--vcs-type=github`` uses received parameters
   to report build ('check') start
8. Depending on build result, Universum either reports build success or failure

After this, check result can be viewed directly on GitHub.

.. note::

    GitHub also sends web-hook payloads on other events (such as *'check run completed'*), that are
    currently ignored by GitHub Handler
