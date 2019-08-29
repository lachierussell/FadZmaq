"""create account table

Revision ID: aae99e39a9c5
Revises: 
Create Date: 2019-08-29 11:52:01.490282

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'aae99e39a9c5'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
                    'test_account2',
                    sa.Column('id', sa.Integer, primary_key=True),
                    sa.Column('name', sa.String(50), nullable=False),
                    sa.Column('description', sa.Unicode(200)),
                    )
    pass


def downgrade():
    pass
