#!/usr/bin/env python
# this is post-commit file for svn

import sys
import os

# Const Definition
RTD_HOST = "10.2.25.103"
RTD_HOST_PORT = 8000
SVN_URL = "http://10.2.25.3/svn/OpenSourcePythonCodes"
# Regex breakdown:
#   [a-z0-9] -- start with alphanumeric value
#   [-._a-z0-9] -- allow dash, dot, underscore, digit, lowercase ascii
#   *? -- allow multiple of those, but be not greedy about the matching
#   (?: ... ) -- wrap everything so that the pattern cannot escape when used in
#                regexes.
VERSION_SLUG_REGEX = '(?:[a-z0-9A-Z][-._a-z0-9A-Z]*?)'
version_SLUG_REGEX = '(?:[-\w]+)'


def main():
    """
    Program Main Func
    """
    # get_svn_log("30")
    if len(sys.argv) > 2:
        # From SVN
        svn_revision = sys.argv[2]
        do_the_job(svn_revision)
    else:
        # From Self Test
        do_the_job("30")


def do_the_job(svn_revision):
    """
    Real Maine
    :param svn_revision:
    :return:
    """
    write_log("Commit Recv: [{0}]".format(" ".join(sys.argv)))
    check_result = check_is_need_builg_from_svn_log(svn_revision)
    if check_result[0]:
        write_log("Build Command: [{0} | {1}]".format(check_result[1], check_result[2]))
        send_build_request(check_result[1], check_result[2])


def write_log(log_content):
    """
    Write Log.
    :param log_content: log content
    :return:
    """
    from datetime import datetime
    log_file_path = os.path.abspath(__file__).replace("post-commit.py", "post-commit.log")
    with open(log_file_path, 'a+') as file:
        file.write("[{0}] {1}\n".format(datetime.now(), log_content))


def get_svn_log(svn_revision):
    """
    Get Svn Log Info From SVN
    :param svn_revision: revision of SVN, str or int
    :type svn_revision: str
    :return: Log Content
    """
    log_content = run_subprocess(['svn', "log","--non-interactive","--username","xiangtao","--password","xt", SVN_URL, "-r", str(svn_revision)])
    write_log("Log Content Of Revision [{0}]:\n{1}".format(svn_revision, log_content.encode('utf8').replace("\r\n","\n")))
    return log_content


def check_is_need_builg_from_svn_log(svn_revision):
    """
    Check is log content call build,Build Command Is [RTDBuild:<ProjectName_Or_ProjectID>|<Version_Flag>],
    With This Comment, we'll try to post a request to build server
    :param svn_revision: revision of SVN, str or int
    :return: Tuple Result, (is_need,project_slug,version_slug)
    """
    import re
    # Build Tag: [RTDBuild:readthedocs|2]
    reg_build_requirement = re.compile(
        r"\[RTDBuild:(?P<project_slug>{0})(\|(?P<version_slug>{1}+))?\]".format(version_SLUG_REGEX, VERSION_SLUG_REGEX),
        re.IGNORECASE)

    log_content = get_svn_log(svn_revision)

    project_slug = None
    version_slug = None
    has_match = False
    cur_match = reg_build_requirement.search(log_content)
    if cur_match:
        has_match = True
        cur_project_info = cur_match.groupdict()
        project_slug = cur_project_info.get("project_slug")
        version_slug = cur_project_info.get("version_slug")

    return (has_match, project_slug, version_slug)


def send_build_request(project_slug, version_slug):
    """
    Send Build Request To Build Server
    :param project_slug: Project Name Or Project ID
    :param version_slug: Version Flag, If None, Builder Will Build It's Default Version
    :return: Status Code And Status Reason
    """
    import httplib, urllib
    con = httplib.HTTPConnection(RTD_HOST, RTD_HOST_PORT)
    build_url = "/build/{0}".format(project_slug)
    params = None
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}

    if version_slug:
        params = urllib.urlencode({'version_slug': version_slug})
        # build_url+="/?version_slug={0}".format(version_slug)
    con.request("POST", build_url, params, headers)
    res = con.getresponse()
    write_log("Send Build Request To: {0}. Response is: {1} {2}\n".format(build_url, res.status, res.reason))


def run_subprocess(cmds, input_data=None):
    """
    Run a sub process, Mainly, Run SVN Commands
    :param cmds: SVN Command And params
    :param input_data: Any Data?
    :return: return the out put of command in utf8 encode
    """
    import subprocess

    stdout = subprocess.PIPE
    stderr = subprocess.PIPE
    stdin = None
    if input_data is not None:
        stdin = subprocess.PIPE

    proc = subprocess.Popen(
        cmds,
        stdin=stdin,
        stdout=stdout,
        stderr=stderr,
    )

    cmd_output = proc.communicate(input=input_data)
    (cmd_stdout, cmd_stderr) = cmd_output
    try:
        output = cmd_stdout.decode('gbk', 'replace')
    except (TypeError, AttributeError):
        output = None
        try:
            error = cmd_stderr.decode('gbk', 'replace')
        except (TypeError, AttributeError):
            error = None
            exit_code = proc.returncode

    return output


if __name__ == '__main__':
    import sys

    sys.exit(int(main() or 0))
