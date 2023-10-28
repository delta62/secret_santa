# Secret Santa

A program for generating secret santa gifter and recipient pairs

Features:

- No cycles will ever be created within the pool of recipients (e.g. in a group
  of 3 or more people, person A gives to person B and person B gives to person
  A)
- Participants can be put into groups. Participants in the same group will never
  be assigned one another. Useful if you are working with people who all live
  together and will have a hard time surprising their assignees
- Integrated email sender notifies participants of their assignments
- Redacted mode doesn't tell you who is assigned to who so that you can
  participate as well! Log files are still saved in case you need to check
  something later.

## Usage

First, install dependencies with `bundle install`.

To run the program, invoke

`bundle exec bin/secret_santa [options]`

```
Options:
  -c, --csv-path=<s>         Path to an input CSV
  -s, --subject=<s>          Subject of sent messages
  -b, --body-template=<s>    Template to use for generated message bodies
  -f, --from-name=<s>        The name to use for the email's from address
  -r, --from-email=<s>       The email address to use for the email's sender
  -e, --redact               Redact generated assignments
  -d, --dry-run              Generate assignments but do not actually send emails
  -h, --help                 Show this message
```

`csv-path`, `subject`, `body-template`, `from-name`, and `from-email` are
required.

### CSV Format

This program reads recipients from a CSV file. The file should not contain a
header row; the first row in the CSV is parsed as a participant.

## | Column | Contents | Required? |

| 1 | Participant name | yes |
| 2 | Participant email | yes |
| 3 | Participant address, line 1 | yes |
| 4 | Participant address, line 2 | yes |
| 5 | Group to place the participant in | no |

These values are available in the generated emails, as described below.

### Email Templates

The email body is a template, and substitutions are performed prior to sending
to a given participant. Template variables are surrounded by braces, such as
`{{name}}`. The following variables are templated in, with values provided in
the CSV:

## | Variable | Value |

| `{{name}}` | Name of the recipient assigned to this participant |
| `{{address1}}` | First address line of the recipient |
| `{{address2}}` | Second address line of the recipient |
