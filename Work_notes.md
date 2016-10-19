to be revised, updated, added to. Need to add reconciliation options, more related works.

# Works

Each Bib Record creates at least 1 Work.

## Work Types

Fixed fields mapping to bf:Work subclasses that indicate "Work types" is area being ironed out. This should be tested and test logic documented ASAP.

This may cause proliferation of existing Work tests to cover assertions like Titles across types.

## Work Core Profile / Identification

Right now, Work testing looks at Titles. Need to expand titles capture but then also start testing for other aspects of the "core" bf:Work profile. This should include tests for:

- bf:Work identifiers (020, 035, 001, other?)
- bf:Work languages
- bf:Work activities (includes creator/contributor agents)
- bf:Work alternate titles

## Additional/Related Works in same Bib Record

Capturing related bf:Work instances to the "main" bf:Work described by the bibliographic record - as well as capturing the nature of the relationship - is an important aspect to test. Below shows a pass at where related or associated Works could be captured in MARC fields.

Difficulties for conversion: consistent mappings with legacy literals, needed reconciliation to match related bf:Work to their existing instances, and separating types of bf:Work to bf:Work relationships described (Whole / Part, Succeeding/Preceding, Editions and versions, Reproductions, other). Some of these relationships will be at the bf:Work to multiple bf:Instances level.

Some of this will be moved/updated with LD4All Target Mapping work. Right now, keeping a list below of possible new / related Works to test for existence of in this suite. Priority is fed by what seems both important for convertor support + confirming non-lossy conversions, but also

MARC Field/Subfield | Related Work information | Priority for this work
====================|==========================|========================
400t | (obsolete) Added entry personal name, $t indicating title. | TBD
410t | (obsolete) Added entry corporate name, $t indicating title. | TBD
411t | (obsolete) Added entry meeting name, $t indicating title. | TBD
440a | (obsolete) Series statement for added entry title. Should be in 490 but this is still somewhat used. | TBD
490a | Series statement for a series title. Bib record represents Work contained in that Series - double check this. | Higher
501 | Bound-with notes, largely. | TBD
510 | citations for Works describing the Bib's main Work. | Lower
525 | supplements. | Lower, harder to define as new Works
530 | other physical or analog forms of the work. may relate to a 776. | Higher
533 | related reproduction (may be applicable, needs review). Often used for Microform & Electronic reproductions; sometimes, photocopies, photograph positives, facsimiles, reel.... Would be helpful to get inventory of $a values. Could apply to only a part of the Work described by the Bib. May describe variances at Instance level. | Higher
534t | Original version | Middling
535 $3 | Name of original or duplicates of the Work that is held by a different Institution. This is probably at varying Instance level but should be reviewed for Work indications. | Needs more work
544d, $3 | Other portions of (mostly?) archival collections. | Lower
555u | finding aids & indexes. changes meaning if archival/visual materials versus serials (see fixed fields for this) | Middling
562 | This is also probably Instance level information. | TBD
581a | Publication based on materials described by Bib. Gives human-readable citation which will be hard to parse. Could be worth analyzing usage in existing catalogs. | TBD
600t | subject - title by the personal name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
610t | subject - title by the corporate name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
611t | subject - title related to the meeting name represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
630 | subject - uniform title entry. | Higher
696t | local subject - title by the personal name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
697t | local subject - title by the corporate name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
698t | local subject - title related to the meeting name represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
699 | local subject - uniform title entry. | Higher
700t | added entry - title by the personal name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
710t | added entry - title by the corporate name/agent represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
711t | added entry - title related to the meeting name represented. May be other subfield values in same field to fill out information about related work (author, language, etc.) | Higher
730 | added entry - uniform title entry. | Higher
740 | added entry - uncontrolled related title entry. | Higher
760 | main series | Middling?
762 | subseries | Middling?
765 | added entry for work in original language | Higher
767 | added entry for a translation of the work described | Higher
770 | supplements and special issues | Middling
772 | supplement "parent" | Middling
773 | Host item | Middling?
774t | Parts / Constituent Units for the Work described | Middling?
775t | Other editions | Higher
780 | Preceding title (often series -> series described)| Higher
785 | Succeeding title | Higher
787t | ... others? Needs review. | TBD
791-799 | Local added entries. Follow pattern of 700-730, though numbering is offer (order is same) | TBD
800t | series added entries (personal name / title) | TBD
810t | series added entries (corporate name / title) | TBD
811t | series added entries (meeting name / title) | TBD
830 | series added entries (uniform title) | Higher
842 | Textual Physical Form Designator ... ? | Lower
843 | Reproduction Note ... ? | Lower
896-9 | Local series added entries | Lower
