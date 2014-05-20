import re
import os
import logging

from lxml import etree

from packtools.utils import setdefault


HERE = os.path.dirname(os.path.abspath(__file__))
SCHEMAS = {
    'SciELO-journalpublishing1.xsd': os.path.join(HERE, 'sps_xsd', 'sps.xsd'),
}
EXPOSE_ELEMENTNAME_PATTERN = re.compile(r"(?<=Element )'.*?'")

logger = logging.getLogger(__name__)


def XMLSchema(schema_name):
    with open(SCHEMAS[schema_name]) as fp:
        xmlschema_doc = etree.parse(fp)

    xmlschema = etree.XMLSchema(xmlschema_doc)
    return xmlschema


class XML(object):
    def __init__(self, file):
        """
        :param file: Path to the XML file or etree.
        """
        if isinstance(file, etree._ElementTree):
            self.lxml = file
        else:
            self.lxml = etree.parse(file)

        self.xmlschema = XMLSchema('SciELO-journalpublishing1.xsd')

    def find(self, tagname, lineno):
        for elem in self.lxml.findall('//' + tagname):
            if elem.sourceline == lineno:
                logger.debug('method *find*: hit a regular element: %s.' % tagname)
                return elem
        else:
            root = self.lxml.getroot()
            if root.tag == tagname:
                logger.debug('method *find*: hit a root element.')
                return root


    def validate(self):
        result = setdefault(self, '__validation_result', lambda: self.xmlschema.validate(self.lxml))
        errors = setdefault(self, '__validation_errors', lambda: self.xmlschema.error_log)
        return result, errors

    def annotate_errors(self):
        result, errors = self.validate()

        for error in errors:
            match = EXPOSE_ELEMENTNAME_PATTERN.search(error.message)
            if match is None:
                raise ValueError('Could not locate the element name in %s.' % error.message)
            else:
                element_name = match.group(0).strip("'")

            err_element = self.find(element_name, error.line)
            if err_element is None:
                raise ValueError('Could not locate the erratic element %s at line %s to annotate: %s.' % (element_name, error.line, error.message))

            notice_element = etree.Element('SPS-ERROR')
            notice_element.text = error.message
            try:
                err_element.addprevious(notice_element)
            except TypeError:
                # In case of a root element, a comment if added.
                err_element.addprevious(etree.Comment('SPS-ERROR: %s' % error.message))

    def __str__(self):
        return etree.tostring(self.lxml, pretty_print=True,
            encoding='utf-8', xml_declaration=True)

    def __unicode__(self):
        return str(self).decode('utf-8')

    def __repr__(self):
        return '<packtools.stylechecker.XML xml=%s valid=%s>' % (self.lxml, self.validate()[0])

    def read(self):
        """
        Read the XML contents as text.
        """
        return unicode(self)


if __name__ == '__main__':
    import argparse
    import sys

    parser = argparse.ArgumentParser(description='stylechecker cli utility.')
    parser.add_argument('--annotated', action='store_true')
    parser.add_argument('xmlpath', help='Absolute or relative path to the XML file.')

    args = parser.parse_args()
    xml = XML(args.xmlpath)

    is_valid, errors = xml.validate()

    if args.annotated:
        xml.annotate_errors()
        sys.stdout.write(str(xml))

    else:
        if not is_valid:
            print 'Invalid XML! Found %s errors:' % len(errors)
            for err in errors:
                print '%s,%s\t%s' % (err.line, err.column, err.message)
        else:
            print 'Valid XML! ;)'
